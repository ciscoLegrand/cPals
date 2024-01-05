# frozen_string_literal: true

OpenAI.configure do |config|
  config.access_token = Rails.application.credentials.openai_api_key
  # config.organization_id = ENV.fetch("OPENAI_ORGANIZATION_ID") # Optional.
end
