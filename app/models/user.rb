class User < ApplicationRecord
  has_many :books, dependent: :destroy
  has_many :chapters, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_books, through: :favorites, source: :book
  has_many :active_relationships,   class_name: 'Relationship',
                                    inverse_of: :follower,
                                    foreign_key: 'follower_id',
                                    dependent: :destroy
  has_many :passive_relationships,  class_name: 'Relationship',
                                    inverse_of: :followed,
                                    foreign_key: 'followed_id',
                                    dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  attr_accessor :remember_token, :activation_token, :reset_token # インスタンス変数を直接変更して操作ができるようにする。

  before_save :downcase_email
  before_create :create_activation_digest # create前に呼び出される
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze
  mount_uploader :image, UserImageUploader

  validates :name,
            presence: true,
            length: { maximum: 50 }
  validates :email,
            presence: true,
            length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password,
            presence: true,
            length: { minimum: 6 },
            allow_nil: true
  validate  :image_size
  # クラスメソッド定義
  class << self
    # ランダムなトークンを作る(クラスメソッド)
    def new_token
      SecureRandom.urlsafe_base64
    end

    # 暗号化したトークンを作成(クラスメソッド)
    def digest(string)
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create(string, cost: cost)
    end

    def guest
      find_or_create_by!(email: 'guest@example.com', name: 'ゲスト') do |user|
        user.password = SecureRandom.urlsafe_base64
      end
    end
  end
    # 永続セッションのために、暗号化したトークンをDBに代入する
  def remember
    self.remember_token = User.new_token # ユーザーのremember_token属性を設定している。selfをつけないとローカル変数になる。
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # トークンがダイジェストと一致したらtrueを返す
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?

    BCrypt::Password.new(digest).is_password?(token)
  end

  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end

  # アカウント有効化メール送信
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # アカウントを有効にする
  def activate
    update_attribute(:activated, true)
  end

  # パスワード再設定の属性を設定する
  # コントローラで使うため、Userクラスを超える。よってprivateには置けない。
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  # パスワード再設定メール送信
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

# お気に入り登録

  # お気に入り登録する
  def like(book)
    favorite_books << book
  end

  # お気に入り登録解除
  def unlike(book)
    favorites.find_by(book_id: book.id).destroy
  end

  # 現在のユーザーがお気に入り登録してたらtrueを返す
  def like?(book)
    favorite_books.include?(book)
  end

# ユーザーフォロー

  # ユーザーをフォローする
  def follow(other_user)
    following << other_user
  end

  # ユーザーをフォロー解除する
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # 現在のユーザーがフォローしてたらtrueを返す
  def following?(other_user)
    following.include?(other_user)
  end

  private

  # Userクラス内でしか使わないためprivate(余計なスコープを広げないため)
    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end

    def downcase_email
      email.downcase!
    end
end
