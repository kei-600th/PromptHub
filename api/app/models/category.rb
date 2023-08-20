class Category < ApplicationRecord
  has_many :samples, dependent: :destroy

  validates :name, presence: true
end
