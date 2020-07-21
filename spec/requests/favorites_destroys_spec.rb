require 'rails_helper'

RSpec.describe "FavoritesDestroys", type: :request do
  let(:user) { create(:user) }
  let(:book) { create(:book, user: user) }
  let!(:favorite) { create(:favorite,user: user,book: book) }

  describe "DELETE /favorite" do

    it "ログインしていない場合は無効" do
      expect{
        delete favorite_path(favorite)
        follow_redirect!
      }.not_to change { Favorite.count }
      expect(flash[:warning]).to be_truthy
      expect(request.fullpath).to eq "/login"
    end

    it "ログインしている場合は有効" do
      log_in_as(user)
      expect{
        delete favorite_path(favorite)
        follow_redirect!
      }.to change {Favorite.count}.by(-1)
      expect(request.fullpath).to eq book_path(book)
    end
  end
end
