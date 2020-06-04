class BooksController < ApplicationController

  def index
    @books = Book.page(params[:page]).per(20)
  end

  def show
    @book = Book.find(params[:id])
    @chapters = @book.chapters.page(params[:page]).per(15)
  end
end
