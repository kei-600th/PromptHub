class AddCategoryToSamples < ActiveRecord::Migration[6.1]
  def change
    add_column :samples, :category_id, :bigint, index: true
    add_foreign_key :samples, :categories
  end
end
