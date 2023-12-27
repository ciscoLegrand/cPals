class Interaction < ApplicationRecord
  belongs_to :conversation

  # Define la clase de renderizado personalizado dentro de Interaction
  class CustomRender < Redcarpet::Render::HTML
    def initialize(view_context, options = {})
      super(options)
      @view_context = view_context
    end

    def block_code(code, language)
      UI::Terminal.new(code: CGI.escapeHTML(code), language: language).render_in(@view_context)
    end

    def codespan(code)
      "<code class='px-4 py-1 bg-black text-white rounded-lg'>#{CGI.escapeHTML(code)}</code>"
    end
  end

  def answer_text_to_html(view_context)
    renderer = CustomRender.new(view_context, hard_wrap: true, filter_html: true)
    markdown = Redcarpet::Markdown.new(renderer, fenced_code_blocks: true, no_intra_emphasis: true, autolink: true, tables: true, lax_spacing: true)
    markdown.render(answer_text).html_safe
  end
end
