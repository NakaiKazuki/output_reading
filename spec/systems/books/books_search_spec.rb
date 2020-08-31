require "rails_helper"

RSpec.describe "BooksSearches", type: :system  do
  it "ログインしていなくてもアクセス可能" do
    visit search_books_path
    expect(current_path).to eq search_books_path
  end

  it "楽天検索機能" do
    visit search_books_path
    expect(current_path).to eq search_books_path
    fill_in "本のタイトルを入力してください",with:"検索"
    find(".form-submit").click
    expect(current_path).to eq search_books_path
    expect(page).to have_selector ".result-image"
    expect(page).to have_selector ".result-content"
  end
end
