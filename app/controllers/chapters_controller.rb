class ChaptersController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user
  before_action :right_user,only:[:edit,:update,:destroy]

  def new
    @chapter = current_user.chapters.build if logged_in?
  end

  def create
    @book = Book.find(params[:book_id])
    @chapter = current_user.chapters.build(chapter_params) if logged_in?
    if @chapter.save
      flash[:success] = "#{@chapter.number}章の投稿が作成されました！"
      redirect_to book_path(@book)
    else
      render "new"
    end
  end

  def edit
    @chapter = current_user.chapters.find_by(book_id:params[:book_id],number: params[:number])
  end

  def update
    @book = Book.find(params[:book_id])
    @chapter = current_user.chapters.find_by(book_id: @book,number: params[:number])
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
    current_user.chapters.find_by(book_id:@book,number: params[:number]).destroy
    flash[:success] = "投稿を削除しました。"
    redirect_to @book
  end

private

  def chapter_params
    params.require(:chapter).permit(:number,:content,:image,:book_id)
  end
# beforeアクション
  def correct_user
    @book = Book.find(params[:book_id])
    redirect_to(root_url) unless current_user?(@book.user)
  end

  def right_user
    @chapter = Chapter.find_by(book_id:params[:book_id],number: params[:number])
    redirect_to(root_url) unless current_user?(@chapter.user)
  end
end
