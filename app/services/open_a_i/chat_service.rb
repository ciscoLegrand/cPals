module OpenAI
  class ChatService < BaseService
    attr_reader :conversation, :model, :max_tokens, :temperature

    def initialize(conversation:)
      super(conversation:)
      @messages = []
    end

    def send_message(content)
      @messages << { role: 'user', content: }
      create_user_interaction(content)
      update_chat
    end

    def receive_response
      update_chat['choices'].first['message']['content']
    end

    private

    def update_chat
      response = client.chat(
        parameters: {
          model:,
          messages: @messages,
          max_tokens:,
          temperature:,
          n: RESPONSES_PER_MESSAGE
        }
      )

      @messages << { role: 'assistant', content: response['choices'].first['message']['content'] }
      Rails.logger.info "\n\n 😀OpenAI Response: #{response}"

      update_conversation(response)
      create_system_interaction(response)

      response
    end

    def create_user_interaction(content)
      interaction = @conversation.interactions.build(
        role: 'user',
        model: @conversation.model,
        usage: {},
        content:,
        system_fingerprint: nil
      )
    end

    def create_system_interaction(response)
      interaction = @conversation.interactions.build(
        role: response['choices'].first['message']['role'],
        model: response['model'],
        usage: response['usage'],
        content: response['choices'].first['message']['content'],
        system_fingerprint: response['system_fingerprint']
      )
      interaction.save!
    end

    def update_conversation(response)
      tokens = if @conversation.prompt_settings.blank?
                 0
               else
                 @conversation.prompt_settings['total_tokens']
               end

      tokens += response['usage']['total_tokens']

      @conversation.update! prompt_settings: {
        model:,
        max_tokens:,
        temperature:,
        total_tokens: tokens
      }
    end
  end
end
