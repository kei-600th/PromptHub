class Api::V1::Admin::PromptsController < ApplicationController
  before_action :check_admin, only: :new

  def create
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

end
