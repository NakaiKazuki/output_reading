class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user&.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or user
      else
        redirect_to root_url, flash: { danger: 'メールを確認して、アカウントを有効にしてください。' }
      end
    else
      flash.now[:danger] = 'メールアドレスかパスワードが正しくありません。'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  def new_guest
    user = User.guest
    log_in user
    redirect_to user_path(user), flash: { success: 'ゲストユーザーとしてログインしました。' }
  end
end
