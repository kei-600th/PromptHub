class SampleSerializer < ActiveModel::Serializer
  attributes :id, :title, :description
  has_many :prompts
end
