class ConversationsController < ApplicationController
  before_action :set_conversation, only: %i[show destroy]

  # GET /conversations
  def index
    valid_ranges = %w[today yesterday last_7_days last_30_days].freeze
    range = valid_ranges.include?(params[:range]) ? params[:range] : 'all'
    @conversations = Conversation.send(range).order(created_at: :desc)
    @turbo_frame_title = "conversations_#{range}"
  end

  # GET /conversations/1
  def show; end

  # GET /conversations/new
  def new
    @conversation = Conversation.new
  end

  # POST /conversations
  def create
    @conversation = Conversation.new(conversation_params.except(:description))
    ActiveRecord::Base.transaction do
      generate_and_set_title
      @conversation.save!
      @interaction = Interaction.create(conversation: @conversation, role: 'user', model: @conversation.model, content: conversation_params[:description])

      OpenAi::ChatJob.perform_later(@interaction.conversation_id)
    end

    respond_to do |format|
      flash.now[:success] = { title: "¡Conversación creada!", body: "¡Tu conversación ha sido creada exitosamente! Ahora puedes verla en la lista de conversaciones." }
      format.html { redirect_to @conversation }
      format.turbo_stream
    rescue ActiveRecord::RecordInvalid => e
      flash.now[:error] = { title: "¡Error al crear la conversación!", body: "Hubo un error al crear la conversación. #{e.message}" }
      format.html { render :new, status: :unprocessable_entity }
      format.turbo_stream { render :new, status: :unprocessable_entity }
    end
  end

  # DELETE /conversations/1
  def destroy
    @conversation.destroy!
    redirect_to conversations_url, notice: "Conversation was successfully destroyed."
  end

  private

  def set_conversation
    @conversation = Conversation.find(params[:id])
  end

  def conversation_params
    params.require(:conversation).permit(:user_id, :ip_address, :title, :description, :model)
  end

  def generate_and_set_title
    title_service = OpenAI::TitleGeneratorService.new
    title = title_service.generate_title(conversation_params[:description])
    @conversation.title = title if title.present?
  end
end
