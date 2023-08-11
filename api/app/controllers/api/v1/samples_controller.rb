class Api::V1::SamplesController < ApplicationController
  def index
    samples = Sample.all
    render json: samples
  end

  def show
    sample = Sample.find(params[:id])
    render json: sample
  end

end
