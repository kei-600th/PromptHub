class Api::V1::SamplesController < ApplicationController
  def index
    samples = Sample.includes(:category).all
    samples = filter_by_conditions(samples)
    samples = sort_samples(samples)
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
      favorite_samples = Sample.includes(:category, :likes).where(id: sample_ids).order('created_at DESC')

      # 取得したSampleオブジェクトから、全ての関連するlikesを取得
      favorite_samples.each do |sample|
        sample.likes.reload
      end

      render json: favorite_samples
    else
      render json: { error: 'user_id parameter is missing' }, status: :bad_request
    end
  end

  def filter_by_conditions(samples)
    return filter_by_category_and_model(samples) if params[:category_id] && params[:gpt_model] != "すべてのモデル"
    return filter_by_category_only(samples) if params[:category_id]
    return filter_by_model_only(samples) if params[:gpt_model] != "すべてのモデル"

    samples
  end

  private

  def filter_by_category_and_model(samples)
    samples.joins(:prompts)
           .where(category_id: params[:category_id], prompts: { gpt_model: params[:gpt_model] })
           .distinct
  end

  def filter_by_category_only(samples)
    samples.where(category_id: params[:category_id])
  end

  def filter_by_model_only(samples)
    samples.joins(:prompts)
           .where(prompts: { gpt_model: params[:gpt_model] })
           .distinct
  end

  def sort_samples(samples)
    if params[:is_popular_order] == "true"
      samples.left_outer_joins(:likes)
             .group('samples.id')
             .order('COUNT(likes.id) DESC, samples.created_at DESC')
    else
      samples.order('created_at DESC')
    end
  end
end
