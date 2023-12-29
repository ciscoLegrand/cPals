class OpenAi::ChatJob < ApplicationJob

  def perform(conversation)
    @conversation = conversation
    call_openai
  end

  private

  def call_openai
    message = @conversation.interactions.create(role: 'user', content: '', usage: {}, model: @conversation.model, system_fingerprint: nil, response_number: 0)
    message.broadcast_created

    OpenAI::Client.new.chat(
      parameters: {
        model: @conversation.model,
        messages: Interaction.for_openai(@conversation.interactions),
        temperature: 0.8,
        stream: stream_proc(message),
        n: 1
      }
    )
  end

  def create_messages
    messages = []
    responses_per_message = 1
    responses_per_message.times do |i|
      message = @conversation.interactions.create(role: 'assistant', content: '', usage: {}, model: '', system_fingerprint: nil, response_number: i)
      message.broadcast_created
      messages << message
    end
    messages
  end

  def stream_proc(message)
    proc do |chunk, _bytesize|
      response = JSON.parse(chunk)
      message.update(content: response['choices'][0]['text'])
      message.broadcast_updated
    end
  end
end
