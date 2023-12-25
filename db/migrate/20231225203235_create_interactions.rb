class CreateInteractions < ActiveRecord::Migration[7.1]
  def change
    create_table :interactions do |t|
      t.references :conversation, null: false, foreign_key: true
      t.string :question_text
      t.string :answer_text
      t.jsonb :response_metadata
      t.string :model_used
      t.jsonb :prompt_settings

      t.timestamps
    end
  end
end
