require 'rails_helper'

RSpec.describe Like do
  let(:like) { FactoryBot.create(:like) }

  describe 'Like model' do
    context 'when all required fields are filled' do
      it 'is valid' do
        expect(like).to be_valid
      end
    end
  end

  describe 'sample_id presence' do
    context 'when the sample_id is not present (nil)' do
      before { like.sample_id = nil }

      it 'is invalid' do
        expect(like).not_to be_valid
      end
    end
  end

  describe 'user_id presence' do
    context 'when the user_id is not present (nil)' do
      before { like.user_id = nil }

      it 'is invalid' do
        expect(like).not_to be_valid
      end
    end
  end
end
