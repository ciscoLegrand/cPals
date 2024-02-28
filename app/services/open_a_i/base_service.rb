# frozen_string_literal: true

module OpenAI
  module ClientInitializer
    def setup_client(options = {})
      # uri_base = "http://172.22.112.1:1234" # local environment

      OpenAI::Client.new(
        access_token: ENV.fetch("OPENAI_ACCESS_TOKEN", Rails.application.credentials.OPENAI_ACCESS_TOKEN),
        # uri_base: uri_base,
        **options
      )
    end
  end

  class BaseService
    include ClientInitializer

    DEFAULT_MODEL = 'gpt-3.5-turbo'
    DEFAULT_MAX_TOKENS = 750
    DEFAULT_TEMPERATURE = 0.8
    RESPONSES_PER_MESSAGE = 1

    attr_reader :client, :conversation, :model, :max_tokens, :temperature, :options

    def initialize(max_tokens: DEFAULT_MAX_TOKENS, **options)
      @conversation = options[:conversation]
      @model = @conversation&.model.presence || DEFAULT_MODEL
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
