# frozen_string_literal: true

OpenAI.configure do |config|
  config.access_token = Rails.application.credentials.dig(:openai, :access_token)
  # config.organization_id = ENV.fetch("OPENAI_ORGANIZATION_ID") # Optional.
end
