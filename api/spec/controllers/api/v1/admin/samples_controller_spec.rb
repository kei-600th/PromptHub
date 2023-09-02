require 'rails_helper'

RSpec.describe Api::V1::Admin::SamplesController do
  let(:admin_user) { FactoryBot.create(:user, admin: true) }
  let(:user) { FactoryBot.create(:user) }

  describe 'POST #create' do
    let(:category) { FactoryBot.create(:category) }
    let(:sample_params) { FactoryBot.attributes_for(:sample, category_id: category.id) }
    let(:prompts_params) { [FactoryBot.attributes_for(:prompt)] }

    it 'creates a new sample' do
      expect do
        post :create, params: { sample: sample_params, prompts: prompts_params, user: admin_user.attributes }, xhr: true
      end.to change(Sample, :count).by(1)
    end

    it 'does not create a new sample with non-admin user' do
      expect do
        post :create, params: { sample: sample_params, prompts: prompts_params, user: user.attributes }, xhr: true
      end.not_to change(Sample, :count)
    end

    it 'does not create a new sample with non-logged-in user' do
      expect do
        post :create, params: { sample: sample_params, prompts: prompts_params, user: { id: nil } }, xhr: true
      end.not_to change(Sample, :count)
    end
  end

  describe 'PATCH #update' do
    let!(:sample) { FactoryBot.create(:sample, title: "Old Title") }

    it 'updates the sample with admin user' do
      new_title = "New Title"
      patch :update, params: { id: sample.id, sample: { title: new_title }, user: admin_user.attributes }, xhr: true
      expect(sample.reload.title).to eq(new_title)
    end

    it 'does not update the sample with non-admin user' do
      new_title = "New Title"
      patch :update, params: { id: sample.id, sample: { title: new_title }, user: user.attributes }, xhr: true
      expect(sample.reload.title).not_to eq(new_title)
    end

    it 'does not update the sample with non-logged-in user' do
      new_title = "New Title"
      patch :update, params: { id: sample.id, sample: { title: new_title }, user: { id: nil } }, xhr: true
      expect(sample.reload.title).not_to eq(new_title)
    end
  end

  describe 'DELETE #destroy' do
    let!(:sample) { FactoryBot.create(:sample) }

    it 'deletes the sample' do
      expect do
        delete :destroy, params: { id: sample.id, user: admin_user.attributes }, xhr: true
      end.to change(Sample, :count).by(-1)
    end

    it 'does not deletes the sample with non-admin user' do
      expect do
        delete :destroy, params: { id: sample.id, user: user.attributes }, xhr: true
      end.not_to change(Sample, :count)
    end

    it 'does not deletes the sample with non-logged-in user' do
      expect do
        delete :destroy, params: { id: sample.id, user: { id: nil } }, xhr: true
      end.not_to change(Sample, :count)
    end
  end
end
