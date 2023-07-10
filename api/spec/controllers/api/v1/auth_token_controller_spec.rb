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
    @user.reload
    expect(@user.refresh_jti).to be_nil
    expect(response.body.present?).to be false if error_msg.nil?
    expect(response.body["error"]).to eq(error_msg) if error_msg.present?
  end

  describe "POST #create" do
    context "valid login" do
      it "returns a 200 response" do
        post :create, params: @params, xhr: true
        expect(response).to have_http_status(200)
        access_lifetime_to_i = @access_lifetime.from_now.to_i
        refresh_lifetime_to_i = @refresh_lifetime.from_now.to_i

        # jtiは保存されているか
        @user.reload
        expect(@user.refresh_jti).not_to be_nil

        # レスポンスユーザーは正しいか
        parsed_response = JSON.parse(response.body)
        expect(parsed_response["user"]["id"]).to eq(@user.id)

        # レスポンス有効期限は想定通りか(1誤差許容)
        expect(parsed_response["expires"]).to be_within(1).of(access_lifetime_to_i)

        ## access_token
        access_token = User.decode_access_token(parsed_response[@access_token_key])

        # ユーザーはログイン本人と一致しているか
        expect(access_token.entity_for_user).to eq(@user)

        # 有効期限はレスポンスと一致しているか
        token_exp = access_token.payload["exp"]
        expect(parsed_response["expires"]).to eq(token_exp)

        ## cookie
        # cookieのオプションを取得する場合は下記を使用
        # request.cookie_jar.instance_variable_get(:@set_cookies)[<key>]
        cookie = request.cookie_jar.
                 instance_variable_get(:@set_cookies)[@session_key]

        # expiresは想定通りか(1秒許容)
        expect(cookie[:expires]).to be_within(1.seconds).of(Time.at(refresh_lifetime_to_i))

        # secureは一致しているか
        expect(cookie[:secure]).to eq(Rails.env.production?)

        # http_onlyはtrueか
        expect(cookie[:http_only]).to be true

        ## refresh_token
        token_from_cookies = cookies[@session_key]
        refresh_token = User.decode_refresh_token(token_from_cookies)
        @user.reload

        # ログイン本人と一致しているか
        expect(refresh_token.entity_for_user).to eq(@user)

        # jtiは一致しているか
        expect(@user.refresh_jti).to eq(refresh_token.payload["jti"])
        # token有効期限とcookie有効期限は一致しているか
        expect(refresh_token.payload["exp"]).to be_within(1.second).of(refresh_lifetime_to_i)
      end
    end
  end
end
