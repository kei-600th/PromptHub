class Like < ApplicationRecord
  belongs_to :sample
  belongs_to :user

  validates_uniqueness_of :user_id, scope: :sample_id, message: "既にいいねをつけています"

end
