module ApplicationHelpers

  #ユーザーがログインしていればtrue、その他ならfalseを返す(cookiesに依存しない)
  def is_logged_in?
    !session[:user_id].nil?
  end
end
