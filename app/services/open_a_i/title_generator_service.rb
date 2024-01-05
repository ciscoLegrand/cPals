# frozen_string_literal: true

# rubocop:disable Metrics/MethodLength
module OpenAI
  class TitleGeneratorService < BaseService
    def generate_title(text)
      prompt = <<-PROMPT
        como experto redactor y sintetizador de textos,
        analiza el siguiente texto ' #{text} ',
        sintetiza y genera el título más adecuado que describa el tema a tratar.
        las condiciones son las siguientes:
        1- detecta el idioma del texto.
        2- el título debe ser en el mismo idioma del texto.
        3- el título debe tener mínimo 10 caracteres.
        4- el título no debe superar los 50 caracteres.
        5- no es necesario completar los 50 caracteres.
        6- cuanto mas corto, sencillo y conciso sea el título, mejor.
        7- no es necesario que el título sea una oración completa.
        8- el título debe ser síntesis del tema u objetivo al que se quiere llegar en el texto.
        9- el título debe ser gramaticalmente correcto.
        10- el título debe ser coherente con el texto.
        11- el título debe ser corto, conciso y preciso.
        12- el título debe ser lo mas despcriptivo posible.
        13- el título no puede ser literalmente igual al texto.
        14- En caso de que el texto no sea lo suficientemente descriptivo, el título debe ser lo mas descriptivo posible.
        15- Lo mas importante es que la respuesta solamente esté compuesta por el título, sin ningún otro texto adicional.
      PROMPT

      response = client.chat(
        parameters: {
          model: @model,
          messages: [{ role: 'user', content: prompt }],
          temperature: 1
        }
      )
      extract_title(response)
    rescue StandardError => e
      log_error(e)
      nil
    end

    private

    def extract_title(response)
      response.dig('choices', 0, 'message', 'content').strip
    end
  end
end
# rubocop:enable Metrics/MethodLength
