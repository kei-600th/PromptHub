class PromptSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :request_text, :response_text, :gpt_model, :image

  def image
    return unless object.image.attached?

    "#{ENV.fetch('IMAGE_HOST_URL')}#{rails_blob_url(object.image, only_path: true)}"
  end
end