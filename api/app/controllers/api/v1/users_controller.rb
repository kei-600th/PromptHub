class Api::V1::UsersController < ApplicationController

  def create
    puts params
    user = User.new(user_params)
    # メール認証をスキップする
    user.activated = true
    if user.save
      puts "user created!"
    else
      puts "errormessage: "
      user.errors.full_messages.each do |message|
        puts message
      end
    end
  end

  private
  # ストロングパラメーターの設定
  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end
