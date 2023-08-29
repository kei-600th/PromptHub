class AddUniqueIndexToLikes < ActiveRecord::Migration[6.1]
  def change
    add_index :likes, [:user_id, :sample_id], unique: true
  end
end
