require 'rails_helper'

RSpec.describe Api::V1::SamplesController do
  describe 'GET #index' do
    context 'when category_id and is_popular_order and gpt_model does not exist' do
      it 'returns http success' do
        get :index, xhr: true
        expect(response).to have_http_status(:success)
      end
    end

    context 'when category_id exists' do
      let(:category) { FactoryBot.create(:category) }

      it 'returns http success' do
        get :index, params: { category_id: category.id }, xhr: true
        expect(response).to have_http_status(:success)
      end
    end

    context 'when is_popular_order exists' do
      it 'returns http success' do
        get :index, params: { is_popular_order: true }, xhr: true
        expect(response).to have_http_status(:success)
      end
    end

    context 'when gpt_model exists' do
      it 'returns http success' do
        get :index, params: { gpt_model: 'gpt-3.5-turbo' }, xhr: true
        expect(response).to have_http_status(:success)
      end
    end

    context 'when category_id and is_popular_order and gpt_model exists' do
      let(:category) { FactoryBot.create(:category) }

      it 'returns http success' do
        get :index, params: { category_id: category.id, is_popular_order: true, gpt_model: 'gpt-3.5-turbo' }, xhr: true
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'GET #show' do
    let(:sample) { FactoryBot.create(:sample) }

    it 'returns http success' do
      get :show, params: { id: sample.id }, xhr: true
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #favorite' do
    let(:user) { FactoryBot.create(:user) }

    context 'when user_id exists' do
      it 'returns http success' do
        get :favorite, params: { user_id: user.id }, xhr: true
        expect(response).to have_http_status(:success)
      end
    end

    context 'when user_id does not exist' do
      it 'returns http bad_request' do
        get :favorite, xhr: true
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end
