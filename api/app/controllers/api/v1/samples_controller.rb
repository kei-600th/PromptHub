class Api::V1::SamplesController < ApplicationController
  def index
    samples = Sample.includes(:category).all
    render json: samples
  end

  def show
    sample = Sample.includes(:category).find(params[:id])
    render json: sample
  end
end
