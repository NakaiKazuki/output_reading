require 'rails_helper'

RSpec.describe "BooksCreates", type: :request do

  let(:user) { create(:user) }

  def post_invalid_information
    post books_path,params:{
      book:{
        title: ""
      }
    }
  end

  def post_valid_information
    post books_path,params:{
      book:{
        title: "テスト投稿"
      }
    }
  end

  def post_valid_information_with_image
    post books_path,params:{
      book:{
        title: "テスト投稿",
        image: "spec/fixtures/fixtures/rails.png"
      }
    }
  end


  describe "GET /books/new" do
    describe "無効" do
      it "ユーザーがログインしていないため無効" do
        get new_book_path
        follow_redirect!
        expect(flash[:warning]).to be_truthy
        expect(request.fullpath).to eq "/login"
      end
    end

    describe "有効" do
      it "ユーザーがログインしているため有効" do
        log_in_as(user)
        get new_book_path
        expect(request.fullpath).to eq "/books/new"
      end
    end
  end
  
  describe "Post /books" do
    describe "無効" do
      it "ユーザーがログインしていない場合は無効" do
        expect{
          post_valid_information
        }.not_to change {Book.count}
        follow_redirect!
        expect(flash[:warning]).to be_truthy
        expect(request.fullpath).to eq "/login"
      end

      it "無効な情報" do
        log_in_as(user)
        expect{
          post_invalid_information
        }.not_to change {Book.count}
        expect(request.fullpath).to eq "/books"
      end
    end

    describe "有効" do
      it "ユーザーがログインしている場合は有効" do
        log_in_as(user)
        expect{
          post_valid_information
        }.to change {Book.count}.by(1)
        follow_redirect!
        expect(flash[:success]).to be_truthy
        expect(request.fullpath).to eq "/books/1"
      end

      it "ユーザーログイン状態で画像を追加した投稿の場合でも有効" do
        log_in_as(user)
        expect{
          post_valid_information_with_image
        }.to change {Book.count}.by(1)
        follow_redirect!
        expect(flash[:success]).to be_truthy
        expect(request.fullpath).to eq "/books/1"
      end
    end
  end
end
