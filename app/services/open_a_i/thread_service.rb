module OpenAI
  class ThreadService < BaseService
    def initialize(model: DEFAULT_MODEL, max_tokens: DEFAULT_MAX_TOKENS, **options)
      super # Asegura que las configuraciones por defecto se apliquen
    end

    # Crea un nuevo thread de conversación para un asistente dado.
    # @param assistant_id [String] el ID del asistente para el thread.
    # @return [OpenAI::Thread] el objeto thread creado.
    def create_thread(assistant_id)
      client.threads.create(assistant_id:)
    end

    # Envía un mensaje en un thread específico.
    # @param thread_id [String] el ID del thread al que se envía el mensaje.
    # @param role [String] el rol del remitente del mensaje (por ejemplo, 'user', 'system').
    # @param content [String] el contenido del mensaje.
    # @return [OpenAI::Message] el objeto mensaje enviado.
    def send_message(thread_id, role, content)
      client.messages.create(
        model:,
        thread_id:,
        role:,
        content:,
        max_tokens:,
        **options
      )
    rescue OpenAI::Errors::OpenAIError => e
      log_error(e)
      nil # O manejar el error como sea apropiado
    end
  end
end
