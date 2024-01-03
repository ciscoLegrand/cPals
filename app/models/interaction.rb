# frozen_string_literal: true

class Interaction < ApplicationRecord
  include ActionView::RecordIdentifier

  enum role: { system: 0, assistant: 1, user: 2 }

  belongs_to :conversation

  after_create_commit -> { broadcast_created }
  after_update_commit -> { broadcast_updated }

  def broadcast_created
    Rails.logger.info "\nBROADCAST_CREATED\n🍌 conversation: #{conversation.title}\n🥝 interaction: #{content}\n"
    broadcast_append_later_to(
      "#{dom_id(conversation)}_interactions",
      partial: 'interactions/interaction',
      locals: { interaction: self, scroll_to: true },
      target: "#{dom_id(conversation)}_interactions"
    )
  end

  def broadcast_updated
    Rails.logger.info "\nBROADCAST_UPDATED\n🍌 conversation: #{conversation.title}\n🥝 interaction: #{content}\n"
    broadcast_append_to(
      "#{dom_id(conversation)}_interactions",
      partial: 'interactions/interaction',
      locals: { interaction: self, scroll_to: true },
      target: "#{dom_id(conversation)}_interactions"
    )
  end

  def self.for_openai(messages)
    messages.map { |message| { role: message.role, content: message.content } }
  end

  # Define la clase de renderizado personalizado dentro de Interaction
  class CustomRender < Redcarpet::Render::HTML
    def initialize(view_context, options = {})
      super(options)
      @view_context = view_context
    end

    def block_code(code, language)
      UI::Terminal.new(code: CGI.escapeHTML(code), language:).render_in(@view_context)
    end

    def codespan(code)
      "<code class='px-4 py-1 bg-black text-white rounded-lg'>#{CGI.escapeHTML(code)}</code>"
    end
  end

  def answer_text_to_html(view_context)
    renderer = CustomRender.new(view_context, hard_wrap: true, filter_html: true)
    markdown = Redcarpet::Markdown.new(renderer, fenced_code_blocks: true, no_intra_emphasis: true, autolink: true,
                                                 tables: true, lax_spacing: true)
    markdown.render(content).html_safe
  end
end
