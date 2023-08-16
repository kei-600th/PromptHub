class PromptSerializer < ActiveModel::Serializer
  attributes :id, :request_text, :response_text, :gpt_model
end
