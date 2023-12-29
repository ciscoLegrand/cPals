class InteractionsController < ApplicationController
  include ActionView::RecordIdentifier

  def create
    @interaction = Interaction.create(conversation: @conversation, role: 'user', model: @conversation.model, content: conversation_params[:description])
    conversation = @interaction.conversation
    OpenAi::ChatJob.perform_later(@conversation)

    respond_to(&:turbo_stream)
  end
    # Only allow a list of trusted parameters through.
    def interaction_params
      params.require(:interaction).permit(:conversation_id, :role, :content, :model, :usage, :system_fingerprint)
    end
end
