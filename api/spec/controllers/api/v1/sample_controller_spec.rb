require 'rails_helper'

RSpec.describe Api::V1::SamplesController, type: :controller do

  describe 'GET #index' do
    before do
      get :index, xhr: true
    end

    it 'returns http success' do
      expect(response).to have_http_status(:success)
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

  describe 'POST #create' do
    let(:sample_params) { FactoryBot.attributes_for(:sample) }
    let(:prompt_params) { FactoryBot.attributes_for(:prompt) }

    it 'creates a new sample' do
      expect {
        post :create, params: { sample: sample_params, prompt: prompt_params }, xhr: true
      }.to change(Sample, :count).by(1)
    end
  end


  describe 'PATCH #update' do
    let!(:sample) { FactoryBot.create(:sample) }
    let(:new_sample_params) { FactoryBot.attributes_for(:sample) }

    before do
      patch :update, params: { id: sample.id, sample: new_sample_params }, xhr: true
    end

    it 'updates the sample' do
      expect(sample.reload.title).to eq new_sample_params[:title]
      expect(sample.reload.description).to eq new_sample_params[:description]
    end
  end
  
  describe 'DELETE #destroy' do
    let!(:sample) { FactoryBot.create(:sample) }

    it 'deletes the sample' do
      expect {
        delete :destroy, params: { id: sample.id }, xhr: true
      }.to change(Sample, :count).by(-1)
    end
  end

end