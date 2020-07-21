module SessionsHelper

  # 渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
  end

  # 記憶トークン (cookie) に対応するユーザーを返す
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id) #current_userがある場合はcurrent_userを代入するけど、無い場合はUserモデルからsession使って探して代入する。
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user &&user.authenticated?(:remember,cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # 渡されたユーザーがログイン済みユーザーであればtrueを返す
  def current_user?(user)
    user == current_user
  end

  # ユーザーがログインしていればtrue、その他ならfalseを返す
  def logged_in?
    !current_user.nil?
  end

  # ユーザーがログアウトしていればtrue、その他ならfalseを返す
  def logged_out?
    current_user.nil?
  end

  # 現在のユーザーをログアウトする
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id #cookies.signed IDの暗号化。クッキーを長期間保存 cookies.permanent
    cookies.permanent[:remember_token] = user.remember_token
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # 直前のリンクを記憶する
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end

  #記憶したリンクか任意のリンクにリダイレクトする
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  private
  # ログイン済みユーザーかどうか確認
    def logged_in_user
      unless logged_in?
        store_location
        flash[:warning] = "ログインしてください"
        redirect_to login_url
      end
    end
end
