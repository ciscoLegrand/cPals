# frozen_string_literal: true

module OpenAi
  class ChatJob < ApplicationJob # rubocop:disable Style/Documentation
    queue_as :default

    RESPONSES_PER_MESSAGE = 1

    def perform(conversation_id)
      @conversation = Conversation.find(conversation_id)
      call_openai
      Rails.logger.info '🤖 OpenAI ChatJob finished'
    end

    private

    def call_openai
      OpenAI::Client.new.chat(
        parameters: {
          model: @conversation.model,
          messages: Interaction.for_openai(@conversation.interactions),
          temperature: 0.8,
          stream: stream_proc,
          n: RESPONSES_PER_MESSAGE
        }
      )
    end

    def create_messages
      messages = []
      responses_per_message = 1
      responses_per_message.times do |i|
        Rails.logger.info "Creating message #{i}: #{messages[i]}"
        message = @conversation.interactions.create(role: 'assistant', content: '', response_number: i)
        messages << message
      end
      messages
    end

    def stream_proc
      messages = create_messages
      proc do |chunk, _bytesize|
        new_content = chunk.dig('choices', 0, 'delta', 'content')
        message = messages.find { |m| m.response_number == chunk.dig('choices', 0, 'index') }
        message.update(content: message.content + new_content) if new_content
      end
    end
  end
end
