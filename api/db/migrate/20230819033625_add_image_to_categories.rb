class AddImageToCategories < ActiveRecord::Migration[6.1]
  def change
    add_column :categories, :image, :text
  end
end
