module OpenAI
  class ChatService < BaseService
    attr_reader :model, :max_tokens

    def initialize
      super
      @messages = []
    end

    def send_message(content)
      @messages << { role: 'user', content: content }
      update_chat
    end

    def receive_response
      update_chat['choices'].first['message']['content']
    end

    private

    def update_chat
      response = client.chat(
        parameters: {
          model: model,
          messages: @messages,
          max_tokens: max_tokens
        }
      )
      @messages << { role: 'assistant', content: response['choices'].first['message']['content'] }
      response
    end
  end
end
