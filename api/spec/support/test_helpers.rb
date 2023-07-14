module TestHelpers
  # Add more helper methods to be used by all tests here...

  def active_user
    FactoryBot.create(:user, password: "password1", activated: true) # activate_userを作成
  end

  # api path
  def api(path = "/")
    "/api/v1#{path}"
  end

  # 認可ヘッダ
  def auth(token)
    { Authorization: "Bearer #{token}" }
  end

  # 引数のparamsでログインを行う
  def login(params)
    post api("/auth_token"), xhr: true, params: params
  end

  # ログアウトapi
  def logout
    delete api("/auth_token"), xhr: true
  end

  # レスポンスJSONをハッシュで返す
  def res_body
    JSON.parse(@response.body)
  end
end
