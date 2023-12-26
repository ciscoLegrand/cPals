class UI::Terminal < ViewComponent::Base
  attr_reader :code, :language

  def initialize(code:, language:)
    @code = code
    @language = language
  end
end
