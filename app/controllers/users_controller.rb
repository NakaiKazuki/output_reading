class UsersController < ApplicationController
  before_action :logged_in_user, only: %i[edit update index destroy]
  before_action :correct_user,   only: %i[edit update]
  before_action :admin_user,     only: :destroy
  before_action :check_guest, only: %i[update destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      redirect_to root_url, flash: { info: '認証用メールを送信しました。登録時のメールアドレスから認証を済ませてください。' }
    else
      render 'new'
    end
  end

  def index
    @q = User.ransack(params[:q])
    @users = @q.result(distinct: true).page(params[:page]).per(15)
  end

  def show
    @user = User.find(params[:id])
    @books = @user.books.page(params[:page]).per(10)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to @user, flash: { success: 'プロフィールを更新しました！' }
    else
      flash.now[:danger] = 'プロフィールの編集に失敗しました。'
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    redirect_to users_url, flash: { success: 'ユーザーを削除しました。' }
  end

  def favorite_books
    @user = User.find(params[:id])
    @favorites = @user.favorites
    @books = Book.where(id: @favorites.pluck(:book_id)).page(params[:page]).per(10)
    render 'favorite_books'
  end

  def following
    @title = 'フォロー中一覧'
    @user  = User.find(params[:id])
    @users = @user.following.page(params[:page]).per(15)
    render 'show_follow'
  end

  def followers
    @title = 'フォロワー一覧'
    @user  = User.find(params[:id])
    @users = @user.followers.page(params[:page]).per(15)
    render 'show_follow'
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :image)
    end

# beforeアクション
  # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    # 管理者かどうか確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

    def check_guest
      return unless current_user.email == 'guest@example.com'

      redirect_to user_path(current_user), flash: { danger: 'ゲストユーザーの変更・削除はできません。' }
    end
end
