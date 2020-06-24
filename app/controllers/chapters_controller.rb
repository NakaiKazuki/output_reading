class ChaptersController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user

  def new
    @chapter = current_user.chapters.build if logged_in?
  end

  def create
    @book = Book.find(params[:book_id])
    @chapter = current_user.chapters.build(chapter_params) if logged_in?
    if @chapter.save
      flash[:success] = "本の投稿に新しい章が追加されました！"
      redirect_to book_path(@book)
    else
      render "new"
    end
  end

  def edit
    @book = Book.find(params[:book_id])
    @chapter = Chapter.find_by(book_id:@book,number: params[:number])
  end

  def update
    @book = Book.find(params[:book_id])
    @chapter = Chapter.find_by(book_id:@book,number: params[:number])
    if @chapter.update_attributes(chapter_params)
      flash[:success] = "投稿内容を編集しました！"
      redirect_to @book
    else
      flash.now[:danger] = "投稿内容の編集に失敗しました。"
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:book_id])
    Chapter.find_by(book_id:@book,number: params[:number]).destroy
    flash[:success] = "投稿を削除しました。"
    redirect_to @book
  end

private

  def chapter_params
    params.require(:chapter).permit(:number,:content,:image,:book_id)
  end

  def correct_user
    @book = Book.find(params[:book_id])
    redirect_to(root_url) unless current_user?(@book.user)
  end
end
