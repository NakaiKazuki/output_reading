class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      redirect_to user, flash: { success: 'Output Readingへようこそ！' }
    else
      redirect_to root_url, flash: { danger: '有効化に失敗しました。' }
    end
  end
end
