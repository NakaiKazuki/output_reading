class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update,:index]
  before_action :correct_user,   only: [:edit, :update]

  def new
     @user  = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "#{@user.name} さん Output Readingへようこそ！"
      redirect_to @user
    else
      render "new"
    end
  end

  def index
    @users = User.page(params[:page]).per(16)
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = 'プロフィールを更新しました！'
      redirect_to @user
    else
      flash.now[:danger] = 'プロフィールの編集に失敗しました。'
      render 'edit'
    end
  end

private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

# beforeアクション

# ログイン済みユーザーかどうか確認
    def logged_in_user
      unless logged_in?
        store_location
        flash[:warning] = "ログインしてください"
        redirect_to login_url
      end
    end

  # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

end