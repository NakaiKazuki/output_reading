class FavoritesController < ApplicationController
  before_action :logged_in_user

  def create
    @book = Book.find(params[:book_id])
    current_user.like(@book)
    respond_to do |format|
      format.html { redirect_to @book }
      format.js
    end
  end
  # create.jsで　book_id: @book の追加必要unfavoritedでFavoriteモデル叩く時にbook_idがないため、リダイレクトされない

  def destroy
    favorite = Favorite.find(params[:id])
    @book = Book.find(favorite.book_id)
    current_user.unlike(@book)
    respond_to do |format|
      format.html { redirect_to @book }
      format.js
    end
  end
end
