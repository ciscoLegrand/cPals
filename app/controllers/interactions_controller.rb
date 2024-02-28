# frozen_string_literal: true

class InteractionsController < ApplicationController
  include ActionView::RecordIdentifier

  def create
    @conversation = Conversation.find(params[:conversation_id])
    @interaction = Interaction.create(conversation_id: @conversation.id, role: 'user', model: @conversation.model,
                                      content: interaction_params[:content])

    OpenAi::ChatJob.perform_later(@conversation.id)

    respond_to(&:turbo_stream)
  end

  private

  # Only allow a list of trusted parameters through.
  def interaction_params
    params.require(:interaction)
          .permit(:content)
  end
end
