require "rails_helper"

RSpec.describe "BooksNews", type: :system do

  let(:user) { create(:user,:add_image) }

  def submit_with_invalid_information
    fill_in "本のタイトルを入力してください（50文字以内）",with: " "
    find(".form-submit").click
  end

  def submit_with_valid_information
    fill_in "本のタイトルを入力してください（50文字以内）",with: "テスト投稿"
    find(".form-submit").click
  end

  def submit_with_valid_information_if_add_image
    fill_in "本のタイトルを入力してください（50文字以内）",with: "テスト投稿"
    attach_file("book_image","spec/fixtures/rails.png")
    find(".form-submit").click
  end

  describe "/books/new layout" do
    describe "無効" do
      it "ユーザーがログインしていない場合はアクセス不可" do
        visit new_book_path
        expect(current_path).to eq login_path
        expect(page).to have_selector ".alert-warning"
      end

      it "無効なフォーム" do
        log_in_by(user)
        visit new_book_path
        submit_with_invalid_information
        expect(current_path).to eq books_path
        expect(page).to have_selector ".alert-danger"
        expect(page).to have_selector "#error_explanation"
      end
    end

    describe "有効" do
      it "有効なフォーム" do
        log_in_by(user)
        visit  new_book_path
        submit_with_valid_information
        expect(current_path).to eq book_path(1)
        expect(page).to have_selector ".alert-success"
      end

      it "画像を追加した場合でも有効" do
        log_in_by(user)
        visit  new_book_path
        submit_with_valid_information_if_add_image
        expect(current_path).to eq book_path(1)
        expect(page).to have_selector ".alert-success"
      end
    end
  end
end
