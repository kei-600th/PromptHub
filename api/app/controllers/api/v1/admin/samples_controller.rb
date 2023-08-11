class Api::V1::Admin::SamplesController < ApplicationController

  before_action :check_admin, only: [:create, :update, :destroy]

  def index
    samples = Sample.all
    render json: samples
  end

  def show
    sample = Sample.find(params[:id])
    render json: sample
  end

  def create
    sample = Sample.new(sample_params)
    if sample.save
      handle_sample_creation_success(sample)
    else
      handle_sample_creation_failure
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

  def handle_sample_creation_success(sample)
    create_prompt(sample.id)
    render json: { message: "サンプルとプロンプトの作成に成功しました。" }, status: :created
  rescue RuntimeError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def handle_sample_creation_failure
    render json: { error: "サンプルの作成に失敗しました。" }, status: :unprocessable_entity
  end

  def prompt_params
    params.require(:prompt).permit(:request_text, :response_text)
  end

  def sample_params
    params.require(:sample).permit(:title, :description)
  end

  def create_prompt(parent_id)
    prompt = Prompt.new(prompt_params)
    prompt.sample_id = parent_id
    return if prompt.save

    raise "プロンプトの作成に失敗しました。"
  end
end