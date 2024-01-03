# frozen_string_literal: true

module UI
  class Terminal < ViewComponent::Base
    attr_reader :code, :language

    def initialize(code:, language:)
      @code = code
      @language = language
    end
  end
end
