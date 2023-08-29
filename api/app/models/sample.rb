class Sample < ApplicationRecord
  belongs_to :category
  has_many :prompts, dependent: :destroy
  has_many :likes, dependent: :destroy

  validates :title, presence: true
  validates :description, presence: true
end
