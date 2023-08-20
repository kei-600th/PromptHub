require 'rails_helper'

RSpec.describe Prompt do
  let(:prompt) { FactoryBot.create(:prompt) }

  describe 'Prompt model' do
    context 'when all required fields are filled' do
      it 'is valid' do
        expect(prompt).to be_valid
      end
    end
  end

  describe 'request_text validation' do
    context 'when the request_text is not present (blank)' do
      before { prompt.request_text = '' }

      it 'is invalid' do
        expect(prompt).not_to be_valid
      end
    end
  end

  describe 'response_text validation' do
    context 'when the response_text is not present (blank)' do
      before { prompt.response_text = '' }

      it 'is invalid' do
        expect(prompt).not_to be_valid
      end
    end
  end

  describe 'sample_id presence' do
    context 'when the sample_id is not present (nil)' do
      before { prompt.sample_id = nil }

      it 'is invalid' do
        expect(prompt).not_to be_valid
      end
    end
  end

  describe 'gpt_model presence' do
    context 'when the gpt_model is not present (blank)' do
      before { prompt.gpt_model = '' }

      it 'is invalid' do
        expect(prompt).not_to be_valid
      end
    end
  end
end
