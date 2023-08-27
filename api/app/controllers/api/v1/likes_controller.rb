class Api::V1::LikesController < ApplicationController
  def create
    like = Like.new(like_params)
    if like.save
      render json: { message: "いいねしました" }, status: :created
    else
      render json: { error: "いいねできませんでした" }, status: :unprocessable_entity
    end
  end

  def destroy
    like = Like.find(params[:id])
    if like.destroy
      render json: { message: "いいねを削除しました" }, status: :ok
    else
      render json: { error: "いいねを削除できませんでした" }, status: :unprocessable_entity
    end
  end

  private

  def like_params
    params.require(:like).permit(:user_id, :sample_id)
  end
end
