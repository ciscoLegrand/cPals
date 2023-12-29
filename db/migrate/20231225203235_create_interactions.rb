class CreateInteractions < ActiveRecord::Migration[7.1]
  def change
    create_table :interactions, id: :uuid do |t|
      t.references :conversation, null: false, foreign_key: true, type: :uuid

      t.integer :role, default: 0
      t.string :content
      t.string :model
      t.jsonb :usage
      t.string :system_fingerprint
      t.integer :response_number
      t.timestamps
    end
  end
end
