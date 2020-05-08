class User < ApplicationRecord
  attr_accessor :remember_token
  before_save :downcase_email
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  mount_uploader :image, UserImageUploader

  validates :name,
    presence: true,
    length: {maximum: 50}
  validates :email,
    presence: true,
    length: {maximum: 255},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password,
    presence: true,
    length: {minimum: 6},
    allow_nil: true
  validate  :image_size

  class << self #クラスメソッド定義

    # ランダムなトークンを作る(クラスメソッド)
    def new_token
      SecureRandom.urlsafe_base64
    end

    # 暗号化したトークンを作成(クラスメソッド)
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end
  end
    # 永続セッションのために、暗号化したトークンをDBに代入する
  def remember
    self.remember_token = User.new_token #ユーザーのremember_token属性を設定している。selfをつけないとローカル変数になる。
    update_attribute(:remember_digest,User.digest(remember_token))
  end

  # トークンがダイジェストと一致したらtrueを返す
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end

private

  def downcase_email
    email.downcase!
  end

  # アップロードされた画像のサイズをバリデーションする
  def image_size
    if image.size > 5.megabytes
      errors.add(:image, "は5MB未満にしてください")
    end
  end

end
