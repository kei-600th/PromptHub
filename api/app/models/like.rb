class Like < ApplicationRecord
  belongs_to :sample
  belongs_to :user

  validates :user_id, uniqueness: { scope: :sample_id, message: :already_liked }
end
