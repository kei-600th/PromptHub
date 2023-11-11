class Prompt < ApplicationRecord
  belongs_to :sample

  validates :request_text, presence: true
  validates :response_text, presence: true
  validates :gpt_model, presence: true

  has_one_attached :image
end
