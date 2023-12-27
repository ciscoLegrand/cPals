class CreateConversations < ActiveRecord::Migration[7.1]
  def change
    create_table :conversations, id: :uuid do |t|
      t.integer :user_id
      t.string :ip_address
      t.string :title

      t.timestamps
    end
  end
end
