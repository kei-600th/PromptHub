class Sample < ApplicationRecord
  has_many :prompts, dependent: :destroy

  validates :title, presence: true
  validates :description, presence: true
end
