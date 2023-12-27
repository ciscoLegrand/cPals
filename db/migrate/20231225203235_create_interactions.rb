class CreateInteractions < ActiveRecord::Migration[7.1]
  def change
    create_table :interactions, id: :uuid do |t|
      t.references :conversation, null: false, foreign_key: true, type: :uuid
      t.string :question_text
      t.text :answer_text
      t.jsonb :response_metadata
      t.string :model_used
      t.jsonb :prompt_settings

      # Campos adicionales para almacenar información relevante de la API
      t.jsonb :api_request_details
      t.jsonb :api_response_details

      t.timestamps
    end
  end
end
