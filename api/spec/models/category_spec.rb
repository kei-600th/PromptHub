require 'rails_helper'

RSpec.describe Category, type: :model do
  let(:category) { FactoryBot.build(:category) }

  describe 'バリデーション' do
    context 'nameとimageがあれば' do
      it '有効であること' do
        expect(category).to be_valid
      end
    end

    context 'nameが空の場合' do
      before { category.name = '' }

      it '無効であること' do
        expect(category).not_to be_valid
      end
    end

    context 'imageが空の場合' do
      before { category.image = '' }

      it '有効であること' do
        expect(category).to be_valid
      end
    end
  end
end
