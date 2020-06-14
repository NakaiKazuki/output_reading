require 'rails_helper'

RSpec.describe "BooksDestoys", type: :request do

  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }
  let!(:book) { create(:book, user: user) }
  let!(:other_book) { create(:other_book, user: other_user) }

  describe "DLETE /books/:id" do
    describe "無効" do
      it "ログインしていない時に削除を実行すると、ログイン画面に移動" do
        delete book_path(book)
        follow_redirect!
        expect(flash[:warning]).to be_truthy
        expect(request.fullpath).to eq "/login"
      end

      it "投稿者以外の削除は無効" do
        log_in_as(user)
        expect{delete book_path(other_book)}.to change {Book.count}.by(0)
        follow_redirect!
        expect(request.fullpath).to eq "/"
      end
    end

    describe "有効" do
      it "投稿者による削除は有効" do
        log_in_as(user)
        expect{delete book_path(book)}.to change {Book.count}.by(-1)
        follow_redirect!
        expect(flash[:success]).to be_truthy
        expect(request.fullpath).to eq "/users/1"
      end
    end
  end
end
