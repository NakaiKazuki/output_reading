class BooksController < ApplicationController
  before_action :logged_in_user, only: [:new,:create,:edit,:update,:destroy]
  before_action :correct_user,   only: [:edit, :update,:destroy]

  def new
    @book = current_user.books.build if logged_in?
  end

  def create
    @book = current_user.books.build(book_params)
    if @book.save
      flash[:success] = "新しく本のタイトルがリストに追加されました！"
      redirect_to book_path(@book)
    else
      render "new"
    end
  end

  def index
    @q = Book.ransack(params[:q])
    @books = @q.result(distinct: true).page(params[:page]).per(20)
  end

  def show
    @book = Book.find(params[:id])
    @chapters = @book.chapters.page(params[:page]).per(10)
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      flash[:success] = "投稿タイトルを編集しました！"
      redirect_to @book
    else
      flash.now[:danger] = "投稿タイトルの編集に失敗しました。"
      render "edit"
    end
  end

  def destroy
    Book.find(params[:id]).destroy
    flash[:success] = "投稿を削除しました。"
    redirect_to current_user
  end

  def search
    if params[:keyword].present?
      @books = RakutenWebService::Books::Book.search(title: params[:keyword])
    end
  end

  private

  def book_params
    params.require(:book).permit(:title,:image)
  end

  # beforeアクション
    # 正しいユーザーかどうか確認
    def correct_user
      @book = Book.find(params[:id])
      redirect_to(root_url) unless current_user?(@book.user)
    end
end
