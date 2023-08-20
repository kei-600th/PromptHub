require 'rails_helper'

RSpec.describe Category do
  let(:category) { FactoryBot.build(:category) }

  describe 'Category model' do
    context 'when name and image are present' do
      it 'is valid' do
        expect(category).to be_valid
      end
    end
  end

  describe 'name validation' do
    context 'when the name is blank' do
      before { category.name = '' }

      it 'is invalid' do
        expect(category).not_to be_valid
      end
    end
  end

  describe 'image validation' do
    context 'when the image is blank' do
      before { category.image = '' }

      it 'is valid' do
        expect(category).to be_valid
      end
    end
  end
end
