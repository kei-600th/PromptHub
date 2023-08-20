require 'rails_helper'

RSpec.describe Api::V1::SamplesController do
  describe 'GET #index' do
    context 'category_idが存在しない場合' do
      before do
        get :index, xhr: true
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end
    end

    context 'category_idが存在する場合' do
      let(:category) { FactoryBot.create(:category) }

      before do
        get :index, params: { category_id: category.id }, xhr: true
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'GET #show' do
    let(:sample) { FactoryBot.create(:sample) }

    before do
      get :show, params: { id: sample.id }, xhr: true
    end

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end
  end
end
