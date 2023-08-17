class Api::V1::SamplesController < ApplicationController
  def index
    if params[:category_id]
      samples = Sample.includes(:category).where(category_id: params[:category_id])
    else
      samples = Sample.includes(:category).all
    end
    render json: samples
  end

  def show
    sample = Sample.includes(:category).find(params[:id])
    render json: sample
  end
end
