class Api::V1::Admin::SamplesController < ApplicationController
  before_action :check_admin, only: [:create, :update, :destroy]

  def create
    service = SamplePromptCreationService.new(sample_params, prompt_params)

    if sample = service.call
      render json: { message: "サンプルとプロンプトの作成に成功しました。" }, status: :created
    else
      render json: { error: service.error_message }, status: :unprocessable_entity
    end
  end

  def update
    sample = Sample.find(params[:id])
    if sample.update(sample_params)
      render json: { message: "サンプルの更新に成功しました。" }, status: :ok
    else
      render json: { error: "サンプルの更新に失敗しました。" }, status: :unprocessable_entity
    end
  end

  def destroy
    sample = Sample.find(params[:id])
    if sample.destroy
      render json: { message: "サンプルの削除に成功しました。" }, status: :ok
    else
      render json: { error: "サンプルの削除に失敗しました。" }, status: :unprocessable_entity
    end
  end

  private

  def prompt_params
    params.require(:prompt).permit(:request_text, :response_text)
  end

  def sample_params
    params.require(:sample).permit(:title, :description)
  end
end
