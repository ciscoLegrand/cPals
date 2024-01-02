class CreateConversations < ActiveRecord::Migration[7.1]
  def change
    create_table :conversations, id: :uuid do |t|
      t.references :user, type: :uuid, null: false, foreign_key: true
      t.string  :ip_address
      t.string  :title
      t.string  :model
      t.jsonb   :prompt_settings
      t.timestamps
    end
  end
end
