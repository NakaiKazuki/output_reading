class PasswordResetsController < ApplicationController
  before_action :find_user, only: %i[edit update]
  before_action :valid_user, only: %i[edit update]
  before_action :check_expiration, only: %i[edit update]

  def new; end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      redirect_to root_url, flash: { info: '再設定用のURLを入力したメールを送信しました。' }
    else
      flash[:danger] = 'お使いのメールアドレスは登録されていません。'
      render 'new'
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, :blank)
      render 'edit'
    elsif @user.update(user_params)
      log_in @user
      @user.update_attribute(:reset_digest, nil)
      redirect_to @user, flash: { success: 'パスワードの再設定が完了しました。' }
    else
      render 'edit'
    end
  end

  private

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def find_user
      @user = User.find_by(email: params[:email])
    end

    def valid_user
      return if @user && @user&.activated? && @user&.authenticated?(:reset, params[:id])

      redirect_to new_password_reset_url, flash: { danger: '無効なURLです。再度メールアドレスを入力してください。' }
    end

    def check_expiration
      return unless @user.password_reset_expired?

      flash[:danger] = 'パスワード再設定URLの有効期限が過ぎています。再度メールアドレスを入力してください。'
      redirect_to new_password_reset_url
    end
end
