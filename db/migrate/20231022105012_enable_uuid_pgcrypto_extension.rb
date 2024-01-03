# frozen_string_literal: true

class EnableUuidPgcryptoExtension < ActiveRecord::Migration[7.1]
  def change
    enable_extension 'pgcrypto'
  end
end
