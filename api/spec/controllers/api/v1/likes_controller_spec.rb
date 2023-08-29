require 'rails_helper'

RSpec.describe Api::V1::LikesController do
  let(:sample) { FactoryBot.create(:sample) }
  let(:user) { FactoryBot.create(:user) }

  describe 'POST #create' do
    let(:like_params) { FactoryBot.attributes_for(:like, sample_id: sample.id, user_id: user.id) }

    it 'creates a new like' do
      expect do
        post :create, params: { like: like_params }, xhr: true
      end.to change(Like, :count).by(1)
    end
  end

  describe 'DELETE #destroy' do
    let!(:like) { FactoryBot.create(:like) }

    it 'deletes the like' do
      expect do
        delete :destroy, params: { id: like.id }, xhr: true
      end.to change(Like, :count).by(-1)
    end
  end
end
