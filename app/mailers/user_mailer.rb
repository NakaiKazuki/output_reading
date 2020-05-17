class UserMailer < ApplicationMailer

  def account_activation(user)
    @user = user
    mail to: user.email,subject: "【重要】Output Readingよりアカウント有効化に必要なメールを届けました。"
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: "【重要】Output Readingよりパスワード再設定のためのメールを届けました。"
  end
end
