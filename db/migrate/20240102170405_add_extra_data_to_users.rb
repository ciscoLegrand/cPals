# frozen_string_literal: true

class AddExtraDataToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :name, :string
    add_column :users, :surname, :string
    add_column :users, :username, :string
    add_column :users, :role, :integer, default: 0
    add_column :users, :phone, :string
  end
end
