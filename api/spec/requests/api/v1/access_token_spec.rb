require "rails_helper"

RSpec.describe "AccessToken" do
  include ActiveSupport::Testing::TimeHelpers
  before do
    @user = FactoryBot.create(:user, activated: true) # activate_userに相当するFactoryBotのメソッドが見当たらないため、直接作成しています
    @encode = UserAuth::AccessToken.new(user_id: @user.id)
    @lifetime = UserAuth.access_token_lifetime
  end

  describe "auth_token_methods" do
    # 初期設定値は想定通りか
    it "sets initial values as expected" do
      expect(@encode.send(:algorithm)).to eq "HS256"
      expect(@encode.send(:secret_key)).to eq @encode.send(:decode_key)
      expect(@encode.send(:user_claim)).to eq :sub
      expect(@encode.send(:header_fields)).to eq({ typ: "JWT", alg: "HS256" })
    end

    context "when user_id is nil" do
      let(:user_id) { nil }

      it "returns nil from encryption method" do
        expect(@encode.send(:encrypt_for, user_id)).to be_nil
      end

      it "returns nil from decryption method" do
        expect(@encode.send(:decrypt_for, user_id)).to be_nil
      end
    end

    context "when user_id is invalid" do
      let(:user_id) { "aaaaaa" }

      it "returns nil from decryption method" do
        expect(@encode.send(:decrypt_for, user_id)).to be_nil
      end
    end
  end

  describe "encode_token" do
    # トークン有効期限は期待される時間と同じか(1秒許容)
    it "checks token expiration is expected time with 1 second allowance" do
      expect_lifetime = @lifetime.from_now.to_i
      expect(@encode.send(:token_expiration)).to be_within(1.second).of(expect_lifetime)
    end

    # 発行時の@payloadは想定通りか
    it "checks if @payload at the time of issue is as expected" do
      expect_lifetime = @lifetime.from_now.to_i
      payload = @encode.payload
      user_claim = @encode.send(:user_claim)
      expect(payload[:exp]).to eq(expect_lifetime)
      expect(payload[user_claim]).to eq(@encode.user_id)
      expect(payload[:iss]).to eq(UserAuth.token_issuer)
      expect(payload[:aud]).to eq(UserAuth.token_audience)
    end

    # lifetime_textメソッドは想定通りか
    it "checks if lifetime_text method is as expected" do
      expect(@encode.lifetime_text).to eq("30分")
    end

    context "when lifetime key is present" do
      it "checks if the value of claims has changed" do
        time = 1
        lifetime = time.hour
        payload = { lifetime: lifetime }
        encode = UserAuth::AccessToken.new(user_id: @user.id, payload: payload)
        claims = encode.send(:claims)
        expect_lifetime = lifetime.from_now.to_i
        expect(claims[:exp]).to eq(expect_lifetime)
      end

      # lifetime_textは想定通りか
      it "checks if lifetime_text is as expected" do
        time = 1
        payload = { lifetime: time.hour }
        encode = UserAuth::AccessToken.new(user_id: @user.id, payload: payload)
        expect(encode.lifetime_text).to eq("#{time}時間")
      end
    end
  end

  describe "decode_token" do
    before do
      @decode = UserAuth::AccessToken.new(token: @encode.token)
      @payload = @decode.payload
    end

    it "checks if decoded user matches" do
      token_user = @decode.entity_for_user
      expect(token_user).to eq(@user)
    end

    it "checks if verify_claims is as expected" do
      verify_claims = @decode.send(:verify_claims)
      expect(verify_claims[:iss]).to eq(UserAuth.token_issuer)
      expect(verify_claims[:aud]).to eq(UserAuth.token_audience)
      expect(verify_claims[:algorithm]).to eq(UserAuth.token_signature_algorithm)
      expect(verify_claims[:verify_expiration]).to be_truthy
      expect(verify_claims[:verify_iss]).to be_truthy
      expect(verify_claims[:verify_aud]).to be_truthy
      expect(verify_claims[:sub]).to be_falsy
      expect(verify_claims[:verify_sub]).to be_falsy
    end

    context "when within the validity period" do
      it "does not raise an error" do
        travel_to(@lifetime.from_now - 1.second) do
          expect { UserAuth::AccessToken.new(token: @encode.token) }.not_to raise_error
        end
      end
    end

    context "when after the validity period" do
      it "raises an expired signature error" do
        travel_to(@lifetime.from_now) do
          expect { UserAuth::AccessToken.new(token: @encode.token) }.to raise_error(JWT::ExpiredSignature)
        end
      end
    end

    context "when the token has been tampered with" do
      it "raises a verification error" do
        invalid_token = "#{@encode.token}a"
        expect { UserAuth::AccessToken.new(token: invalid_token) }.to raise_error(JWT::VerificationError)
      end
    end

    context "when the issuer is tampered with" do
      it "raises an invalid issuer error" do
        invalid_token = UserAuth::AccessToken.new(payload: { iss: "invalid" }).token
        expect { UserAuth::AccessToken.new(token: invalid_token) }.to raise_error(JWT::InvalidIssuerError)
      end
    end

    context "when the audience is tampered with" do
      it "raises an invalid audience error" do
        invalid_token = UserAuth::AccessToken.new(payload: { aud: "invalid" }).token
        expect { UserAuth::AccessToken.new(token: invalid_token) }.to raise_error(JWT::InvalidAudError)
      end
    end
  end

  describe "verify_claims" do
    context "when sub option is valid" do
      let(:sub) { @encode.user_id }
      let(:options) { { sub: sub } }
      let(:decode) { UserAuth::AccessToken.new(token: @encode.token, options: options) }
      let(:verify_claims) { decode.send(:verify_claims) }

      it "sets the sub and verify_sub claims correctly" do
        expect(verify_claims[:sub]).to eq(sub)
        expect(verify_claims[:verify_sub]).to be_truthy
      end

      it "returns the correct user" do
        token_user = decode.entity_for_user
        expect(token_user).to eq(@user)
      end
    end

    context "when sub option is invalid" do
      let(:options) { { sub: "invalid" } }

      it "raises an InvalidSubError" do
        expect do
          UserAuth::AccessToken.new(token: @encode.token, options: options)
        end.to raise_error(JWT::InvalidSubError)
      end
    end
  end

  describe "not_active_user" do
    before do
      @not_active = User.create(name: "a", email: "a@a.a", password: "password")
      @encode_token = UserAuth::AccessToken.new(user_id: @not_active.id).token
    end

    it "allows retrieval of non-active users" do
      decode_token_user = UserAuth::AccessToken.new(token: @encode_token).entity_for_user
      expect(decode_token_user).to eq(@not_active)
    end
  end
end
