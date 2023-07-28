class Sample < ApplicationRecord
  has_many :prompts, dependent: :destroy
end
