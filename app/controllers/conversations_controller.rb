# frozen_string_literal: true

class ConversationsController < ApplicationController
  before_action :set_conversation, only: %i[show destroy]

  # GET /conversations
  def index
    valid_ranges = %w[today yesterday last_7_days last_30_days older].freeze
    range = valid_ranges.include?(params[:range]) ? params[:range] : 'all'
    @conversations = Conversation.send(range).order(created_at: :desc)
    @turbo_frame_title = "conversations_#{range}"
  end

  # GET /conversations/1
  def show; end

  # GET /conversations/new
  def new
    client = OpenAI::Client.new
    response = client.models.list
    @models = response['data']
    @conversation = Conversation.new
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  # POST /conversations
  def create
    ActiveRecord::Base.transaction do
      @conversation = current_user.conversations.new(conversation_params.except(:description))
      @conversation.title = generate_title
      @conversation.save!
      @conversation.interactions
                   .create!(role: 'user', model: @conversation.model, content: conversation_params[:description])
    end

    OpenAi::ChatJob.perform_later(@conversation.id)

    respond_to do |format|
      flash.now[:success] = {
        title: '¡Conversación creada!',
        body: '¡Tu conversación ha sido creada exitosamente! Ahora puedes verla en la lista de conversaciones.'
      }
      format.html { redirect_to @conversation }
      format.turbo_stream
    end
  end
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/AbcSize

  # DELETE /conversations/1
  def destroy
    @conversation.destroy!
    respond_to do |format|
      flash.now[:success] = { title: "¡Conversación eliminada!", body: '¡Tu conversación ha sido eliminada exitosamente!' }
      format.html { redirect_to chatia_path }
      format.turbo_stream
    end
  end

  private

  def set_conversation
    @conversation = Conversation.find(params[:id])
  end

  def conversation_params
    params.require(:conversation).permit(:user_id, :ip_address, :title, :description, :model)
  end

  def generate_title
    title_service = OpenAI::TitleGeneratorService.new
    title_service.generate_title(conversation_params[:description])
  end
end
