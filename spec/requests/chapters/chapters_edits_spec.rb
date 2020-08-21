require 'rails_helper'

RSpec.describe "ChaptersEdits", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }
  let(:book) { create(:book, user: user) }
  let(:chapter) { create(:chapter, user: user,book: book) }

  def patch_invalid_information(which_chapter)
    patch book_chapter_path(book_id: which_chapter.book_id,number: which_chapter.number),
    params:{
      chapter:{
        number: 2,
        content: "",
        book_id: which_chapter.book_id
      }
    }
  end

  def patch_valid_information(which_chapter)
    patch book_chapter_path(book_id: which_chapter.book_id,number: which_chapter.number),
    params:{
      chapter:{
        number: 2,
        content: "編集テストcontent",
        book_id: which_chapter.book_id
      }
    }
  end

  def patch_valid_information_add_image(which_chapter)
    patch book_chapter_path(book_id: which_chapter.book_id,number: which_chapter.number),
    params:{
      chapter:{
        number: 2,
        content: "編集テストcontent",
        book_id: which_chapter.book_id,
        image: "spec/fixtures/fixtures/rails.png"
      }
    }
  end

  describe "GET /books/:book_id/chapters/:number/edit" do
    describe "無効" do
      it "ユーザーがログインしていないため無効" do
        get edit_book_chapter_path(book_id: chapter.book_id,number:chapter.number)
        follow_redirect!
        expect(flash[:warning]).to be_truthy
        expect(request.fullpath).to eq "/login"
      end

      it "投稿者が一致していないため無効" do
        log_in_as(other_user)
        get edit_book_chapter_path(book_id: chapter.book_id,number:chapter.number)
        follow_redirect!
        expect(request.fullpath).to eq root_path
      end
    end

    describe "有効" do
      it "正しいユーザーのアクセスのため有効" do
        log_in_as(user)
        get edit_book_chapter_path(book_id: chapter.book_id,number:chapter.number)
        expect(request.fullpath).to eq edit_book_chapter_path(book_id: chapter.book_id,number:chapter.number)
      end
    end
  end

  describe "PATCH /books/:book_id/chapters/:number" do
    describe "無効" do
      it "ログインしていない場合編集は無効" do
        patch_valid_information(chapter)
        follow_redirect!
        expect(flash[:warning]).to be_truthy
        expect(request.fullpath).to eq login_path
      end

      it "無効な情報" do
        log_in_as(user)
        patch_invalid_information(chapter)
        expect(flash[:danger]).to be_truthy
        expect(request.fullpath).to eq "/books/1/chapters/1"
      end

      it "他人の投稿は編集できない" do
        log_in_as(other_user)
        patch_valid_information(chapter)
        follow_redirect!
        expect(request.fullpath).to eq root_path
      end
    end

    describe "有効" do
      it "有効な情報" do
        log_in_as(user)
        patch_valid_information(chapter)
        follow_redirect!
        expect(flash[:success]).to be_truthy
        expect(chapter.reload.number).to eq 2
        expect(chapter.reload.content).to eq "編集テストcontent"
        expect(chapter.reload.image).to be_truthy
        expect(request.fullpath).to eq book_path(chapter.book_id)
      end

      it "画像を追加した場合でも有効" do
        log_in_as(user)
        patch_valid_information(chapter)
        follow_redirect!
        expect(flash[:success]).to be_truthy
        expect(chapter.reload.number).to eq 2
        expect(chapter.reload.content).to eq "編集テストcontent"
        expect(chapter.reload.image).to be_truthy
        expect(request.fullpath).to eq book_path(chapter.book_id)
      end
    end
  end
end
