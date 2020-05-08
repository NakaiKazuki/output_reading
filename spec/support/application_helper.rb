module ApplicationHelpers

  #ユーザーがログインしていればtrue、その他ならfalseを返す(cookiesに依存しない)
  def is_logged_in?
    !session[:user_id].nil?
  end

  def log_in_as(user, remember_me = 0)
    get login_path
    post login_path, params: {
      session: {
        email: user.email,
        password: user.password,
        remember_me: remember_me
      }
    }
    follow_redirect!
  end

  def log_in_by(user,remember_me = 0)
    visit login_path
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: user.password
    check "session_remember_me" if remember_me == 1
    find(".form-submit").click
  end

end
