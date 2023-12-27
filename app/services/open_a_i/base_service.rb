module OpenAI
  module ClientInitializer
    def setup_client(options = {})
      OpenAI::Client.new(
        access_token: Rails.application.credentials.openai_access_token,
        **options
      )
    end
  end

  class BaseService
    include ClientInitializer

    DEFAULT_MODEL = 'gpt-3.5-turbo'
    DEFAULT_MAX_TOKENS = 750

    attr_reader :client, :model, :max_tokens, :options

    def initialize(model: DEFAULT_MODEL, max_tokens: DEFAULT_MAX_TOKENS, **options)
      @model = model
      @max_tokens = max_tokens
      @client = setup_client(options)
    end

    # Método genérico para enviar peticiones
    def send_request(endpoint, parameters)
      client.public_send(endpoint, parameters)
    rescue StandardError => e
      log_error(e)
      raise
    end

    private

    def log_error(error)
      Rails.logger.error "OpenAI Error: #{error.message} \n #{error.backtrace.join("\n")}"
    end
  end
end
