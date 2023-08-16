class SampleSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :category_id
  belongs_to :category
  has_many :prompts
end
