require "rails_helper"

RSpec.describe Api::V1::AuthTokenController, type: :controller do
  before do
    @user = active_user
    @params = { auth: { email: @user.email, password: "password1" } }
    @access_lifetime = UserAuth.access_token_lifetime
    @refresh_lifetime = UserAuth.refresh_token_lifetime
    @session_key = UserAuth.session_key.to_s
    @access_token_key = "token"
  end

  # tokenのリフレッシュを行うapi
  def refresh_api
    post :refresh
  end

  # 無効なリクエストで返ってくるレスポンスチェック
  def response_check_of_invalid_request(status, error_msg = nil)
    expect(response.status).to eq(status)
  end

  describe "POST #create" do
    context "valid login" do
      before do
        post :create, params: @params, xhr: true
        @parsed_response = JSON.parse(response.body)
        @access_token = User.decode_access_token(@parsed_response[@access_token_key])
        @user.reload
        @refresh_lifetime_to_i = @refresh_lifetime.from_now.to_i
      end
  
      it "returns a 200 response" do
        expect(response).to have_http_status(200)
      end
  
      it "saves the jti" do
        expect(@user.refresh_jti).not_to be_nil
      end
  
      it "returns the correct user" do
        expect(@parsed_response["user"]["id"]).to eq(@user.id)
      end
  
      it "sets the correct access token expiration" do
        access_lifetime_to_i = @access_lifetime.from_now.to_i
        expect(@parsed_response["expires"]).to be_within(1).of(access_lifetime_to_i)
      end
  
      it "decodes the correct user from access token" do
        expect(@access_token.entity_for_user).to eq(@user)
      end
  
      it "matches the expiration of the access token with the response" do
        token_exp = @access_token.payload["exp"]
        expect(@parsed_response["expires"]).to eq(token_exp)
      end
  
      context "cookies" do
        before do
          @cookie = request.cookie_jar.instance_variable_get(:@set_cookies)[@session_key]
          @refresh_lifetime_to_i = @refresh_lifetime.from_now.to_i
        end
  
        it "sets the correct cookie expiration" do
          expect(@cookie[:expires]).to be_within(1.seconds).of(Time.at(@refresh_lifetime_to_i))
        end
  
        it "sets the correct cookie secure option" do
          expect(@cookie[:secure]).to eq(Rails.env.production?)
        end
  
        it "sets the cookie http_only option to true" do
          expect(@cookie[:http_only]).to be true
        end
      end
  
      context "refresh token" do
        before do
          token_from_cookies = cookies[@session_key]
          @refresh_token = User.decode_refresh_token(token_from_cookies)
          @user.reload
        end
  
        it "decodes the correct user from refresh token" do
          expect(@refresh_token.entity_for_user).to eq(@user)
        end
  
        it "matches the jti with the refresh token" do
          expect(@user.refresh_jti).to eq(@refresh_token.payload["jti"])
        end
  
        it "matches the expiration of the refresh token with the cookie" do
          expect(@refresh_token.payload["exp"]).to be_within(1.second).of(@refresh_lifetime_to_i)
        end
      end

      context "invalid login" do
        it "returns a 404 response for an incorrect user" do
          pass = "password"
          invalid_params = { auth: { email: @user.email, password: pass + "a" } }
          post :create, params: invalid_params, xhr: true
          response_check_of_invalid_request 404
        end
    
        it "returns a 404 response for an inactive user" do
          pass = "password"
          inactive_user = User.create(name: "a", email: "a@a.a", password: pass)
          invalid_params = { auth: { email: inactive_user.email, password: pass } }
          expect(inactive_user).not_to be_activated
          post :create, params: invalid_params, xhr: true
          response_check_of_invalid_request 404
        end
    
        it "returns a 403 response for a non-Ajax request" do
          post :create, params: @params, xhr: false
          response_check_of_invalid_request 403, "Forbidden"
        end
      end
    end
  end
  
end
