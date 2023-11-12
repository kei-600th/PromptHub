class Api::V1::Admin::PromptsController < ApplicationController
  before_action :check_admin, only: :create

  def create
    return if params[:prompt][:gpt_model] == 'gpt-4-vision-preview' && !validate_image_data

    prompt = Prompt.new(prompt_params)

    prompt.response_text = OpenaiChatService.new(params[:messages], prompt.gpt_model).chat
    render json: prompt
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  def prompt_params
    params.require(:prompt).permit(:request_text, :response_text, :gpt_model)
  end

  def validate_image_data
    image_data = params[:prompt][:image]
    if image_data&.match(%r{\Adata:image/(png|jpg|jpeg);base64,})
      true
    else
      render json: { error: 'Invalid image data' }, status: :unprocessable_entity
      false
    end
  end
end
