require "rails_helper"

RSpec.describe "RefreshToken" do
  before do
    @user = FactoryBot.create(:user, activated: true) # activate_userに相当するFactoryBotのメソッドが見当たらないため、直接作成しています
    @encode = UserAuth::RefreshToken.new(user_id: @user.id)
    @lifetime = UserAuth.refresh_token_lifetime
  end

  # エンコード
  describe "encode_token" do
    # payload[:exp]の値は想定通りか(1秒許容)
    it "checks the value of payload[:exp]" do
      payload = @encode.payload
      expect_lifetime = @lifetime.from_now.to_i
      expect(payload[:exp]).to be_within(1.second).of(expect_lifetime)
    end

    # payload[:jti]の値は想定通りか
    it "checks the value of payload[:jti]" do
      payload = @encode.payload
      encode_user = @encode.entity_for_user
      expect_jti = encode_user.refresh_jti
      expect(payload[:jti]).to eq(expect_jti)
    end

    # payload[:sub]の値は想定通りか
    it "checks the value of payload[:sub]" do
      payload = @encode.payload
      user_claim = @encode.send(:user_claim)
      expect(payload[user_claim]).to eq(@encode.user_id)
    end
  end

  # デコード
  describe "decode_token" do
    # デコードユーザーは一致しているか
    it "checks if the decoded user matches" do
      decode = UserAuth::RefreshToken.new(token: @encode.token)
      token_user = decode.entity_for_user
      expect(token_user).to eq(@user)
    end

    # verify_claimsは想定通りか
    it "checks if verify_claims are as expected" do
      decode = UserAuth::RefreshToken.new(token: @encode.token)
      verify_claims = decode.send(:verify_claims)
      expect(verify_claims[:verify_expiration]).to be_truthy
      expect(verify_claims[:algorithm]).to eq(UserAuth.token_signature_algorithm)
    end

    # 有効期限後トークンはエラーを吐いているか
    it "throws an error when token is expired" do
      Timecop.travel(@lifetime.from_now) do
        expect { UserAuth::RefreshToken.new(token: @encode.token) }
          .to raise_error(JWT::ExpiredSignature)
      end
    end

    # トークンが書き換えられた場合エラーを吐いているか
    it "throws an error when token is tampered with" do
      invalid_token = "#{@encode.token}a"
      expect { UserAuth::RefreshToken.new(token: invalid_token) }
        .to raise_error(JWT::VerificationError)
    end
  end

  # デコードオプション
  describe "verify_claims" do
    # userのjtiが正常の場合
    it "checks jti when user's jti is normal" do
      @user.reload
      expect(@user.refresh_jti).to eq(@encode.payload[:jti])
      expect { UserAuth::RefreshToken.new(token: @encode.token) }.not_to raise_error
    end

    # userのjtiが不正な場合
    it "throws an error when user's jti is invalid" do
      @user.remember("invalid")
      expect { UserAuth::RefreshToken.new(token: @encode.token) }
        .to raise_error(JWT::InvalidJtiError, "Invalid jti")
    end

    # rubocop:disable RSpec/ExampleLength

    # userにjtiが存在しない場合
    it "throws an error when user's jti does not exist" do
      @user.reload
      @user.forget
      @user.reload
      expect(@user.refresh_jti).to be_nil
      expect { UserAuth::RefreshToken.new(token: @encode.token) }
        .to raise_error(JWT::InvalidJtiError)
    end

    # rubocop:enable RSpec/ExampleLength
  end
end
