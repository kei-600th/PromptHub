class AddRefreshJtiToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :refresh_jti, :string
  end
end