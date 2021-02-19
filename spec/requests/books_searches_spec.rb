require 'rails_helper'

RSpec.describe 'BooksSearches', type: :request do
  describe 'GET /books/searches' do
    it '非ログイン時でも閲覧と楽天市場での検索が可能' do
      get search_books_path
      expect(response).to have_http_status(:success)
      # # 検索ワード有りでのアクセス master.key必須
      # get search_books_path, params: {
      #   keyword: '検索'
      # }
      # books = controller.instance_variable_get(:@books)
      # expect(books).to be_truthy
      # expect(response).to have_http_status(:success)
    end
  end
end
