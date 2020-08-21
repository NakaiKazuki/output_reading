require "rails_helper"

RSpec.describe "BooksIndices", type: :system  do

  let(:user) { create(:user,:add_image) }
  let(:other_user) { create(:other_user) }
  let!(:other_book) { create(:other_book,:add_image,user: other_user) }

  describe "/books layout" do
    it "ログインしていなくてもアクセス可能" do
      visit books_path
      expect(current_path).to eq books_path
    end

    it "投稿検索機能" do
      visit books_path
      expect(current_path).to eq books_path
      expect(page).to have_link other_book.title,href: book_path(other_book)
      fill_in "検索ワードを入力",with: "foobar"
      find(".search-submit").click
      expect(page).not_to have_link other_book.title,href: book_path(other_book)
      fill_in "検索ワードを入力",with: other_book.title
      find(".search-submit").click
      expect(page).to have_link other_book.title,href: book_path(other_book)
    end

    it "ページネーションで表示される投稿数1ページ20個。投稿に画像があれば追加で表示" do
      create_list(:books,21,user: user)
      log_in_by(user)
      visit books_path
      expect(current_path).to eq books_path
      expect(page).to have_selector ".pagination"
      expect(page).to have_selector ".user-name",count:20
      expect(page).to have_selector ".book-title",count:20
      expect(page).to have_selector ".book-image",count:1
    end

    it "ユーザーがプロフィール画像を設定していれば、設定されている画像を表示する。なければデフォルト画像を表示" do
      log_in_by(user)
      visit books_path
      expect(current_path).to eq books_path
      expect(page).to have_selector ".user-image"
      expect(page).to have_selector ".user-image-default"
    end

    it "一覧内の投稿者名をクリックで、そのユーザーのプロフィール画面へ移動" do
      log_in_by(user)
      visit books_path
      expect(current_path).to eq books_path
      find_link(other_user.name,href: user_path(other_user)).click
      expect(current_path).to eq user_path(other_user)
    end

    it "一覧内の投稿内容をクリックで、投稿詳細へ移動" do
      log_in_by(user)
      visit books_path
      expect(current_path).to eq books_path
      find_link(other_book.title,href: book_path(other_book)).click
      expect(current_path).to eq book_path(other_book)
    end
  end
end
