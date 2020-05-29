class BooksController < ApplicationController

  def index
    @books = Book.page(params[:page]).per(20)
  end

end
