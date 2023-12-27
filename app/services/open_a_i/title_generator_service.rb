module OpenAI
  class TitleGeneratorService < BaseService
    def generate_title(text)
      prompt = "Resume el siguiente texto en un título corto: '#{text}'\n El título no debe superar las 8 palabras. \nEl título debe ser lo mas corto posible y lo mas descriptivo posible."
      response = client.chat(
        parameters: {
          model: @model,
          messages: [{ role: "user", content: prompt }],
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
      response.dig("choices", 0, "message", "content").strip
    end
  end
end
