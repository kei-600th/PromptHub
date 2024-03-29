require 'rails_helper'

RSpec.describe Api::V1::Admin::PromptsController do
  describe 'Post #create' do
    let(:prompt_params) { FactoryBot.attributes_for(:prompt) }
    let(:user_params) { FactoryBot.attributes_for(:user) }

    it 'raises an error with non-admin user' do
      post :create, params: { prompt: prompt_params, user: user_params }, xhr: true
      expect(response).to have_http_status(:forbidden)
    end

    it 'raises an error with non-logged-in user' do
      post :create, params: { prompt: prompt_params, user: { id: nil } }, xhr: true
      expect(response).to have_http_status(:forbidden)
    end
  end
end
