# frozen_string_literal: true

module UI
  class Notification < ViewComponent::Base
    attr_reader :data, :type, :assets

    NOTIFICATION_TYPES = {
      success: {
        icon: 'circle-check',
        color: 'green-500',
        bg_color: 'green-100',
        dark_bg_color: 'green-800',
        dark_text_color: 'green-200'
      },
      error: {
        icon: 'alert-triangle',
        color: 'red-500',
        bg_color: 'red-100',
        dark_bg_color: 'red-800',
        dark_text_color: 'red-200'
      },
      alert: {
        icon: 'alert-triangle',
        color: 'orange-500',
        bg_color: 'orange-100',
        dark_bg_color: 'orange-700',
        dark_text_color: 'orange-200'
      },
      notice: {
        icon: 'info-square-rounded',
        color: 'blue-500',
        bg_color: 'blue-200',
        dark_bg_color: 'blue-800',
        dark_text_color: 'blue-200'
      }
    }.freeze

    def initialize(type:, data:)
      super
      @data = prepare_data(data)
      @data[:timeout] ||= 50_000
      @type = type
      @assets = NOTIFICATION_TYPES[type.to_sym]
    end

    def prepare_data(data)
      case data
      when Hash
        data.with_indifferent_access
      else
        { body: data }.with_indifferent_access
      end
    end
  end
end
