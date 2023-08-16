class SampleSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :category_id
  has_many :prompts
end
