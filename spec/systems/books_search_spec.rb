require 'rails_helper'

RSpec.describe 'BooksSearches', type: :system do
  it 'ログインしていなくてもアクセス可能' do
    visit search_books_path
    expect(page).to have_current_path search_books_path, ignore_query: true
    expect(page).not_to have_selector '.result-image'
    expect(page).not_to have_selector '.result-content'
  end

  # master.key必須
  # it '楽天検索機能' do
  #   visit search_books_path
  #   expect(page).to have_current_path search_books_path, ignore_query: true
  #   fill_in '本のタイトルを入力してください', with: '検索'
  #   find('.form-submit').click
  #   expect(page).to have_current_path search_books_path, ignore_query: true
  #   expect(page).to have_selector '.result-image'
  #   expect(page).to have_selector '.result-content'
  # end
end
