require 'rails_helper'

RSpec.describe Api::V1::CategoriesController do
  describe 'GET #index' do
    before do
      get :index, xhr: true
    end

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end
  end
end
