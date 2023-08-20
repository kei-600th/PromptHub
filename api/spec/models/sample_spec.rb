require 'rails_helper'

RSpec.describe Sample do
  let(:sample) { FactoryBot.create(:sample) }
  let!(:prompt) { FactoryBot.create(:prompt, sample: sample) }

  describe 'Sample model' do
    context 'when all required fields are filled' do
      it 'is valid' do
        expect(sample).to be_valid
      end
    end
  end

  describe 'title validation' do
    context 'when the title is not present (blank)' do
      before { sample.title = '' }

      it 'is invalid' do
        expect(sample).not_to be_valid
      end
    end
  end

  describe 'description validation' do
    context 'when the description is not present (blank)' do
      before { sample.description = '' }

      it 'is invalid' do
        expect(sample).not_to be_valid
      end
    end
  end

  describe 'category_id presence' do
    context 'when the category_id is not present (nil)' do
      before { sample.category_id = nil }

      it 'is invalid' do
        expect(sample).not_to be_valid
      end
    end
  end

  describe 'prompts destruction' do
    context 'when the sample is destroyed' do
      before { sample.destroy }

      it 'destroys associated prompts' do
        expect(Prompt.where(id: prompt.id)).to be_empty
      end
    end
  end
end
