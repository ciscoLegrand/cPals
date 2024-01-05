# frozen_string_literal: true

module UI
  class UserCard < ViewComponent::Base
    attr_reader :user

    def initialize(user:, style:)
      super
      @user = user || guest
      @style = style
    end

    def container_style
      @style[:container]
    end

    def dropdown_style
      @style[:dropdown]
    end

    # rubocop:disable Metrics/LineLength
    def button_style
      'flex justify-start items-center w-full px-4 py-2 text-sm leading-5 text-left gap-2 hover:bg-slate-900 hover:text-white focus:outline-none focus:bg-gray-700 focus:text-white hover:cursor-pointer rounded-lg'
    end

    def text_style
      'text-gray-200 font-semibold'
    end

    def avatar_style
      if @user.email.eql?('guest')
        'border-2 border-indigo-600 rounded-full shadow-lg bg-amber-800 border-amber-700 text-white hover:text-red-500'
      else
        'border-2 border-indigo-600 rounded-full shadow-lg bg-indigo-800 border-indigo-700 text-white hover:text-red-500'
      end
    end
    # rubocop:enable Metrics/LineLength

    def guest
      User.new(email: 'guest', username: 'Guest')
    end

    def links
      [
        { text: 'Profile', path: '#', icon: 'icons/cards/user-cog.svg' },
        { text: 'Settings', path: '#', icon: 'icons/cards/adjustments.svg' },
        { text: 'My Plan', path: '#', icon: 'icons/cards/credit-card.svg' },
        { text: 'Sign out', path: destroy_user_session_path, icon: 'icons/cards/logout.svg' }
      ]
    end
  end
end
