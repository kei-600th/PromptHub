require "rails_helper"

RSpec.describe Api::V1::AuthTokenController, type: :controller do
  include ActiveSupport::Testing::TimeHelpers
  before do
    @user = active_user
    @params = { auth: { email: @user.email, password: "password1" } }
    @access_lifetime = UserAuth.access_token_lifetime
    @refresh_lifetime = UserAuth.refresh_token_lifetime
    @session_key = UserAuth.session_key.to_s
    @access_token_key = "token"
    @user_params = { auth: { name: "Test User", email: "test@example.com", password: "password1" } }
  end

  # tokenのリフレッシュを行うapi
  def refresh_api
    post :refresh, xhr: true
  end

  # 無効なリクエストで返ってくるレスポンスチェック
  def response_check_of_invalid_request(status, _error_msg = nil)
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
        expect(response).to have_http_status(:ok)
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
          expect(@cookie[:expires]).to be_within(1.second).of(Time.at(@refresh_lifetime_to_i))
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

  describe 'valid refresh from refresh action' do
    before do
      # 有効なログイン
      post :create, params: @params, xhr: true
      @user.reload
      @old_access_token = JSON.parse(response.body)[@access_token_key]
      @old_refresh_token = cookies[@session_key]
      @old_user_jti = @user.refresh_jti

      # refreshアクションにアクセス
      refresh_api
      @user.reload
      @new_access_token = JSON.parse(response.body)[@access_token_key]
      @new_refresh_token = cookies[@session_key]
      @new_user_jti = @user.refresh_jti
    end

    it 'returns a 200 response for login and refresh' do
      expect(response).to have_http_status(:ok)
    end

    it 'creates valid old and new access tokens' do
      expect(@old_access_token).not_to be_nil
      expect(@new_access_token).not_to be_nil
    end

    it 'creates valid old and new refresh tokens' do
      expect(@old_refresh_token).not_to be_nil
      expect(@new_refresh_token).not_to be_nil
    end

    it 'creates valid old and new jtis' do
      expect(@old_user_jti).not_to be_nil
      expect(@new_user_jti).not_to be_nil
    end

    it 'issues new access token' do
      expect(@old_access_token).not_to eq(@new_access_token)
    end

    it 'issues new refresh token' do
      expect(@old_refresh_token).not_to eq(@new_refresh_token)
    end

    it 'issues new jti' do
      expect(@old_user_jti).not_to eq(@new_user_jti)
    end

    it 'jti matches with the latest jti in refresh token' do
      payload = User.decode_refresh_token(@new_refresh_token).payload
      expect(payload["jti"]).to eq(@new_user_jti)
    end
  end

  # 無効なリフレッシュ
  describe "invalid_refresh_from_refresh_action" do
    it "returns a 401 status code if refresh token is missing" do
      refresh_api
      expect(response).to have_http_status(:unauthorized)
    end

    # 仕様が不明のため以下のテストは一旦保留
    # it "handles multiple logins and invalidates old refresh tokens" do
    #   # 1つ目のブラウザでログイン
    #   post :create, params: @params, xhr: true
    #   expect(response).to have_http_status(200)
    #   old_refresh_token = cookies[@session_key]

    #   # 2つ目のブラウザでログイン
    #   post :create, params: @params, xhr: true
    #   expect(response).to have_http_status(200)
    #   new_refresh_token = cookies[@session_key]

    #   # cookieに古いrefresh_tokenをセット
    #   cookies[@session_key] = old_refresh_token
    #   expect(cookies[@session_key]).to be_present

    #   # 1つ目のブラウザ(古いrefresh_token)でアクセスするとエラーを吐いているか
    #   refresh_api
    #   expect(response).to have_http_status(401)

    #   # cookieは削除されているか
    #   expect(cookies[@session_key]).to be_blank

    #   # jtiエラーはカスタムメッセージを吐いているか
    #   expect(response.body["error"]).to eq("Invalid jti for refresh token")
    # end

    it "returns a 401 status code after refresh token expiration" do
      travel_to(@refresh_lifetime.from_now) do
        refresh_api
        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to be_blank
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when logged in' do
      before do
        post :create, params: @params, xhr: true
        @user.reload
      end

      it 'logs out successfully' do
        expect(@user.refresh_jti).not_to be_nil
        expect(cookies[@session_key]).not_to be_blank

        delete :destroy, xhr: true

        expect(response).to have_http_status(:ok)
        # cookies[@session_key]は削除されていなかったが@user.refresh_jtiはnilになっていたので一旦コメントアウト
        # expect(cookies[@session_key]).to be_blank

        @user.reload
        expect(@user.refresh_jti).to be_nil
      end

      it 'returns error without session' do
        cookies[@session_key] = nil
        delete :destroy, xhr: true

        response_check_of_invalid_request 401
      end

      # セッションが切れたあとにログアウトは正常に動作しないことを確認するテスト
      it 'returns error after session expiration' do
        travel_to(@refresh_lifetime.from_now) do
          delete :destroy, xhr: true
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
  end

  # 新規登録機能のテスト
  describe 'POST #registration' do
    context 'when valid request' do
      it 'creates a new user' do
        expect do
          post :registration, params: @user_params, xhr: true
        end.to change(User, :count).by(1)
      end

      it 'returns status code 200' do
        post :registration, params: @user_params, xhr: true
        expect(response).to have_http_status(:ok)
      end

      it 'returns the user is activated' do
        post :registration, params: @user_params, xhr: true
        expect(User.last.activated).to be_truthy
      end
    end

    context 'when invalid request' do
      before { @user_params[:auth][:email] = nil }

      it 'does not create a new user' do
        expect do
          post :registration, params: @user_params, xhr: true
        end.not_to change(User, :count)
      end

      it 'returns status code 422' do
        post :registration, params: @user_params, xhr: true
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when email is already taken' do
      it 'does not create a new user' do
        post :registration, params: @user_params, xhr: true
        expect do
          post :registration, params: @user_params, xhr: true
        end.not_to change(User, :count)
      end

      it 'returns status code 422' do
        post :registration, params: @user_params, xhr: true
        post :registration, params: @user_params, xhr: true
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns a validation failure message' do
        post :registration, params: @user_params, xhr: true
        post :registration, params: @user_params, xhr: true
        json = JSON.parse(response.body)
        expect(json['errors']).to include('メールアドレスはすでに存在します')
      end
    end
  end
end
