class Category < ApplicationRecord
  has_many :samples

  validates :name, presence: true
end
