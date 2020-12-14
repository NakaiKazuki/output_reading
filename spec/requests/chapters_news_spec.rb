require 'rails_helper'

RSpec.describe "ChaptersNews", type: :request do

  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }
  let(:book) { create(:book, user: user) }

  def post_invalid_information
    post book_chapters_path(book),params:{
      chapter:{
        number: "",
        content: "",
        book_id: book.id
      }
    }
  end

  def post_valid_information
    post book_chapters_path(book),params:{
      chapter:{
        number: "1",
        content: "テストcontent",
        book_id: book.id
      }
    }
  end

  def post_valid_information_with_image
    post book_chapters_path(book),params:{
      chapter:{
        number: 1,
        content: "テストcontent",
        book_id: book.id,
        image: "spec/fixtures/fixtures/rails.png"
      }
    }
  end

  describe "GET /books/:book_id/chapters/new" do
    describe "無効" do
      it "ユーザーがログインしていないため無効" do
        get new_book_chapter_path(book_id: book)
        follow_redirect!
        expect(flash[:warning]).to be_truthy
        expect(request.fullpath).to eq "/login"
      end

      it "投稿者が一致していないため無効" do
        log_in_as(other_user)
        get new_book_chapter_path(book_id: book)
        follow_redirect!
        expect(request.fullpath).to eq "/"
      end
    end

    describe "有効" do
      it "正しいユーザーのアクセスのため有効" do
        log_in_as(user)
        get new_book_chapter_path(book_id: book)
        expect(request.fullpath).to eq "/books/1/chapters/new"
      end
    end
  end

  describe "Post /books/:book_id/chapters" do
    describe "無効" do
      it "ユーザーがログインしていない場合は無効" do
        expect{
          post_valid_information
        }.not_to change {Chapter.count}
        follow_redirect!
        expect(flash[:warning]).to be_truthy
        expect(request.fullpath).to eq "/login"
      end

      it "投稿者が一致していないため無効" do
        log_in_as(other_user)
        expect{
          post_valid_information
        }.not_to change {Chapter.count}
        follow_redirect!
        expect(request.fullpath).to eq "/"
      end

      it "無効な情報" do
        log_in_as(user)
        expect{
          post_invalid_information
        }.not_to change {Chapter.count}
        expect(request.fullpath).to eq "/books/1/chapters"
      end
    end

    describe "有効" do
      it "正しいユーザーがログインしている場合は有効" do
        log_in_as(user)
        expect{
          post_valid_information
        }.to change{ Chapter.count }.by(1)
        follow_redirect!
        expect(flash[:success]).to be_truthy
        expect(request.fullpath).to eq "/books/1"
      end

      it "ユーザーログイン状態で画像を追加した投稿の場合でも有効" do
        log_in_as(user)
        expect{
          post_valid_information_with_image
        }.to change{ Chapter.count }.by(1)
        follow_redirect!
        expect(flash[:success]).to be_truthy
        expect(request.fullpath).to eq "/books/1"
      end
    end
  end
end
