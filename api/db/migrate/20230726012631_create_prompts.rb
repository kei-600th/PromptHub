class CreatePrompts < ActiveRecord::Migration[6.1]
  def change
    create_table :prompts do |t|
      t.references :sample, foreign_key: true, null: false
      t.text :request_text, null: false
      t.text :response_text, null: false

      t.timestamps
    end
  end
end
