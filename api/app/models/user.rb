require "validator/email_validator"

class User < ApplicationRecord
  include TokenGenerateService

  has_many :likes, dependent: :destroy

  before_validation :downcase_email

  has_secure_password

  validates :name, presence: true,
                   length: { maximum: 30, allow_blank: true }

  validates :email, presence: true,
                    email: { allow_blank: true }

  VALID_PASSWORD_REGEX = /\A[\w\-]+\z/.freeze
  validates :password, presence: true,
                       length: { minimum: 8,
                                 allow_blank: true },
                       format: {
                         with: VALID_PASSWORD_REGEX,
                         message: :invalid_password,
                         allow_blank: true
                       },
                       allow_nil: true

  ## methods
  # class method  ###########################
  class << self
    # emailからアクティブなユーザーを返す
    def find_by_activated(email)
      find_by(email: email, activated: true)
    end
  end
  # class method end #########################

  # 自分以外の同じemailのアクティブなユーザーがいる場合にtrueを返す
  def email_activated?
    users = User.where.not(id: id)
    users.find_by(email: email, activated: true).present?
  end

  # 　リフレッシュトークンのJWT IDを記憶する
  def remember(jti)
    update!(refresh_jti: jti)
  end

  def forget
    update!(refresh_jti: nil)
  end

  # 共通のJSONレスポンス
  def response_json(payload = {})
    as_json(only: [:id, :name, :admin]).merge(payload).with_indifferent_access
  end

  private

  # email小文字化
  def downcase_email
    email&.downcase!
  end
end
