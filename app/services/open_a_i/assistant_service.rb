module OpenAI
  class AssistantService < BaseService
    def initialize(model: DEFAULT_MODEL, max_tokens: DEFAULT_MAX_TOKENS, **options)
      super # Llama al inicializador de BaseService con las configuraciones por defecto
    end

    # Crea un asistente con el modelo y nombre especificados.
    # @param model [String] el nombre del modelo para el asistente.
    # @param name [String] un nombre único para el asistente.
    # @return [OpenAI::Assistant] el objeto asistente creado.
    def create_assistant(model, name)
      client.assistants.create(model: model, name: name)
    end

    # Envía un mensaje a través de un asistente y obtiene una respuesta.
    # @param prompt [String] el texto del prompt para enviar al asistente.
    # @return [String] la respuesta del asistente.
    def send_message(prompt)
      response = client.completions.create(
        model: model,
        prompt: prompt,
        max_tokens: max_tokens,
        **options
      )
      response.choices.first&.text.strip
    rescue OpenAI::Errors::OpenAIError => e
      log_error(e)
      nil # O manejar el error como sea apropiado
    end
  end
end
