class Api::V1::SamplesController < ApplicationController
  def index
    samples = if params[:category_id]
                Sample.includes(:category).where(category_id: params[:category_id])
              else
                Sample.includes(:category).all
              end
    render json: samples
  end

  def show
    sample = Sample.includes(:category).find(params[:id])
    render json: sample
  end

  def favorite
    if params[:user_id]
      # user_idにマッチするSampleオブジェクトを取得
      sample_ids = Like.where(user_id: params[:user_id]).pluck(:sample_id)
      favorite_samples = Sample.includes(:category, :likes).where(id: sample_ids)
  
      # 取得したSampleオブジェクトから、全ての関連するlikesを取得
      favorite_samples.each do |sample|
        sample.likes.reload
      end
      
      render json: favorite_samples
    else
      render json: { error: 'user_id parameter is missing' }, status: :bad_request
    end
  end
end
