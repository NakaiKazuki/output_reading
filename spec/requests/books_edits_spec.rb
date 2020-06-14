require 'rails_helper'

RSpec.describe "BooksEdits", type: :request do

  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }
  let(:book) { create(:book, user: user) }
  let(:other_book) { create(:other_book, user: other_user) }

  def patch_invalid_information(which_book)
    patch book_path(which_book),params:{
      book:{
        title: "  "
      }
    }
  end

  def patch_valid_information(which_book)
    patch book_path(which_book),params:{
      book:{
        title: "投稿内容の編集"
      }
    }
  end

  def patch_valid_information_add_image(which_book)
    patch book_path(which_book),params:{
      book:{
        title: "投稿内容の編集",
        image: "spec/fixtures/fixtures/rails.png"
      }
    }
  end

  describe "GET /books/:id/edit" do
    describe "無効" do
      it "ログインしていない場合はアクセスできない" do
        get edit_book_path(book)
        follow_redirect!
        expect(flash[:warning]).to be_truthy
        expect(request.fullpath).to eq "/login"
      end

      it "異なるユーザーの投稿編集画面へのアクセスは不可" do
        log_in_as(user)
        get edit_book_path(other_book)
        follow_redirect!
        expect(request.fullpath).to eq "/"
      end
    end

    describe "有効" do
      it "ログインしている場合はアクセス可能" do
        log_in_as(user)
        get edit_book_path(book)
        expect(request.fullpath).to eq "/books/1/edit"
      end
    end
  end

  describe "PATCH /books/:id" do
    describe "無効" do
      it "ログインしていない場合編集は無効" do
        patch_valid_information(book)
        follow_redirect!
        expect(flash[:warning]).to be_truthy
        expect(request.fullpath).to eq "/login"
      end

      it "無効な情報" do
        log_in_as(user)
        patch_invalid_information(book)
        expect(flash[:danger]).to be_truthy
        expect(request.fullpath).to eq "/books/1"
      end

      it "他人の投稿は編集できない" do
        log_in_as(user)
        patch_valid_information(other_book)
        follow_redirect!
        expect(request.fullpath).to eq "/"
      end
    end

    describe "有効" do
      it "有効な情報" do
        log_in_as(user)
        patch_valid_information(book)
        expect(flash[:success]).to be_truthy
        expect(book.reload.title).to eq "投稿内容の編集"
        expect(request.fullpath).to eq book_path(book)
      end

      it "画像を追加した場合でも有効" do
        log_in_as(user)
        patch_valid_information_add_image(book)
        expect(flash[:success]).to be_truthy
        expect(book.reload.title).to eq "投稿内容の編集"
        expect(book.reload.image).to be_truthy
        expect(request.fullpath).to eq book_path(book)
      end
    end
  end
end
