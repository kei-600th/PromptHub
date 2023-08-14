class AddGptModelToPrompts < ActiveRecord::Migration[6.1]
  def change
    add_column :prompts, :gpt_model, :string, null: false
  end
end
