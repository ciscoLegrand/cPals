class ConversationsController < ApplicationController
  before_action :set_conversation, only: %i[show edit update destroy]

  # GET /conversations
  def index
    valid_ranges = %w[today yesterday last_7_days last_30_days].freeze
    range = valid_ranges.include?(params[:range]) ? params[:range] : 'all'

    @conversations = Conversation.send(range).order(created_at: :desc)
    @turbo_frame_title = "conversations_#{range}"
  end

  # GET /conversations/1
  def show
  end

  # GET /conversations/new
  def new
    @conversation = Conversation.new
  end

  # GET /conversations/1/edit
  def edit
  end

  # POST /conversations
  def create
    @conversation = Conversation.new(conversation_params.except(:description, :model))

    respond_to do |format|
      ActiveRecord::Base.transaction do
        generate_and_set_title
        @conversation.save!
        create_initial_interaction
      end

      flash.now[:success] = { title: "¡Conversación creada!", body: "¡Tu conversación ha sido creada exitosamente! Ahora puedes verla en la lista de conversaciones." }
      format.html { redirect_to @conversation }
      format.turbo_stream
    rescue ActiveRecord::RecordInvalid => e
      flash.now[:error] = { title: "¡Error al crear la conversación!", body: "Hubo un error al crear la conversación. #{e.message}" }
      format.html { render :new, status: :unprocessable_entity }
      format.turbo_stream { render :new, status: :unprocessable_entity }
    end
  end

  # PATCH/PUT /conversations/1
  def update
    respond_to do |format|
      ActiveRecord::Base.transaction do
        @conversation.update!(conversation_params.except(:description, :model))
        add_interaction
      end

      flash.now[:success] = "¡Conversación actualizada!"
      @interaction = @conversation.interactions.last
      format.html { redirect_to @conversation }
      format.turbo_stream
    rescue ActiveRecord::RecordInvalid => e
      flash.now[:error] = { title: "¡Error al actualizar la conversación!", body: "Hubo un error al actualizar la conversación. #{e.message}" }
      format.html { render :edit, status: :unprocessable_entity }
      format.turbo_stream { render :edit, status: :unprocessable_entity }
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

  def create_initial_interaction
    chat_service = OpenAI::ChatService.new
    chat_service.send_message(conversation_params[:description])
    response = chat_service.receive_response

    interaction = @conversation.interactions.build(
      question_text: conversation_params[:description],
      answer_text: response,
      response_metadata: {}, # Agrega los metadatos necesarios aquí
      model_used: conversation_params[:model],
      prompt_settings: { max_tokens: chat_service.max_tokens },
      api_request_details: { prompt: conversation_params[:description] },
      api_response_details: { full_response: response }
    )
    interaction.save!
  end

  def add_interaction
    chat_service = OpenAI::ChatService.new
    chat_service.send_message(conversation_params[:description])
    response = chat_service.receive_response

    interaction = @conversation.interactions.build(
      question_text: conversation_params[:description],
      answer_text: response,
      response_metadata: {}, # Agrega los metadatos necesarios aquí
      model_used: @conversation.interactions.first.model_used,
      prompt_settings: { max_tokens: chat_service.max_tokens },
      api_request_details: { prompt: conversation_params[:description] },
      api_response_details: { full_response: response }
    )
    interaction.save!
  end
end
