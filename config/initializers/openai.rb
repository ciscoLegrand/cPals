# frozen_string_literal: true

OpenAI.configure do |config|
  config.access_token = ENV.fetch("OPENAI_ACCESS_KEY", Rails.application.credentials.OPENAI_ACCESS_KEY)
  # config.organization_id = ENV.fetch("OPENAI_ORGANIZATION_ID") # Optional.
end
