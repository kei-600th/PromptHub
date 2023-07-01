require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.build(:user) }

  #user.nameバリデーションテスト
  describe 'name validation' do

    # 入力必須
    context 'when name is not present' do
      before { user.name = '' }

      it 'is invalid' do
        expect(user).not_to be_valid
        expect(user.errors.full_messages).to include('名前を入力してください')
      end
    end

    # 文字数制限
    context 'when name is too long' do
      before { user.name = 'a' * 31 }

      it 'is invalid' do
        expect(user).not_to be_valid
        expect(user.errors.full_messages).to include('名前は30文字以内で入力してください')
      end
    end

    # 30文字以内は正しく保存されているか
    context 'when name is less than or equal to 30 characters' do
      before { user.name = 'あ' * 30 }

      it 'is valid and can be saved' do
        expect(user).to be_valid
        expect{ user.save }.to change(User, :count).by(1)
      end
    end


    #user.emailバリデーションテスト
    describe 'email validation' do

      # 入力必須
      context 'when email is not present' do
        before { user.email = '' }
  
        it 'is invalid' do
          expect(user).not_to be_valid
          expect(user.errors.full_messages).to include('メールアドレスを入力してください')
        end
      end
  
      # 文字数制限
      context 'when email is too long' do
        let(:domain) { '@example.com' }
        let(:email) { 'a' * (256 - domain.length) + domain }
  
        before { user.email = email }
  
        it 'is invalid' do
          expect(email.length).to be > 255
          expect(user).not_to be_valid
          expect(user.errors.full_messages).to include('メールアドレスは255文字以内で入力してください')
        end
      end
  
      # 書式チェック format = /\A\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*\z/
      context 'when email format is valid' do
        let(:valid_emails) { %w[A@EX.COM a-_@e-x.c-o_m.j_p a.a@ex.com a@e.co.js 1.1@ex.com a.a+a@ex.com] }
  
        it 'is valid' do
          valid_emails.each do |email|
            user.email = email
            expect(user).to be_valid
          end
        end
      end
  
      # 間違った書式はエラーを吐いているか
      context 'when email format is invalid' do
        let(:invalid_emails) { %w[aaa a.ex.com メール@ex.com a~a@ex.com a@|.com a@ex. .a@ex.com a＠ex.com Ａ@ex.com a@?,com １@ex.com "a"@ex.com a@ex@co.jp] }
  
        it 'is invalid' do
          invalid_emails.each do |email|
            user.email = email
            expect(user).not_to be_valid
            expect(user.errors.full_messages).to include('メールアドレスは不正な値です')
          end
        end
      end
    end
  
    # email小文字化テスト
    describe 'email downcase' do
      let(:email) { 'USER@EXAMPLE.COM' }
  
      before do
        user.email = email
        user.save
      end
  
      it 'is saved as downcase' do
        expect(user.reload.email).to eq email.downcase
      end
    end

    # アクティブユーザーの一意性テスト
    describe 'active user uniqueness' do
      let(:email) { "test@example.com" }

      # アクティブユーザーがいない場合、同じメールアドレスが登録できているか
      context 'when there is no active user' do
        it 'allows multiple users with the same email' do
          expect { 3.times { FactoryBot.create(:user, email: email) } }.to change(User, :count).by(3)
        end
      end
  
      # ユーザーがアクティブになった場合、バリデーションエラーを吐いているか
      context 'when a user becomes active' do
        let!(:active_user) { FactoryBot.create(:user, email: email, activated: true) }
  
        it 'does not allow a new user with the same email' do
          expect { FactoryBot.create(:user, email: email) }.to raise_error(ActiveRecord::RecordInvalid, /メールアドレスはすでに存在します/)
          expect(User.count).to eq 1
        end
      end
  
      # アクティブユーザーがいなくなった場合、ユーザーは保存できているか
      context 'when the active user is destroyed' do
        let!(:active_user) { FactoryBot.create(:user, email: email, activated: true) }
      
        before { active_user.destroy }
      
        it 'allows a new user with the same email' do
          expect { FactoryBot.create(:user, email: email, activated: true) }.to change(User, :count).by(1)
          expect(User.where(email: email, activated: true).count).to eq 1
        end
      end
    end

    # user.passwordバリデーションテスト
    describe 'password validation' do
      let(:user) { User.new(name: "test", email: "test@example.com") }
  
      # 入力必須
      context 'when password is blank' do
        it 'should not be valid' do
          user.password = nil
          expect(user).not_to be_valid
          expect(user.errors.full_messages).to include('パスワードを入力してください')
        end
      end
  
      # min文字以上
      context 'when password is less than 8 characters' do
        it 'should not be valid' do
          user.password = 'a' * 7
          expect(user).not_to be_valid
          expect(user.errors.full_messages).to include('パスワードは8文字以上で入力してください')
        end
      end
  
      # max文字以下
      context 'when password is more than 72 characters' do
        it 'should not be valid' do
          user.password = 'a' * 73
          expect(user).not_to be_valid
          expect(user.errors.full_messages).to include('パスワードは72文字以内で入力してください')
        end
      end
  
      # 書式チェック VALID_PASSWORD_REGEX = /\A[\w\-]+\z/
      context 'when password format is valid' do
        let(:ok_passwords) { 
          [
            'pass---word',
            '________',
            '12341234',
            '____pass',
            'pass----',
            'PASSWORD'
          ]
        }
        
        it 'should be valid' do
          ok_passwords.each do |password|
            user.password = password
            expect(user).to be_valid
          end
        end
      end
  
      # 書式チェック VALID_PASSWORD_REGEX = /\A[\w\-]+\z/
      context 'when password format is invalid' do
        let(:ng_passwords) {
          [
            'pass/word',
            'pass.word',
            '|~=?+"a',
            '１２３４５６７８',
            'ＡＢＣＤＥＦＧＨ',
            'password@'
          ]
        }
        
        it 'should not be valid' do
          ng_passwords.each do |password|
            user.password = password
            expect(user).not_to be_valid
            expect(user.errors.full_messages).to include('パスワードは半角英数字•ﾊｲﾌﾝ•ｱﾝﾀﾞｰﾊﾞｰが使えます')
          end
        end
      end
    end

  end










end
