class Sample < ApplicationRecord
  belongs_to :category
  has_many :prompts, dependent: :destroy

  validates :title, presence: true
  validates :description, presence: true
  validates :category_id, presence: true
end
