require 'rails_helper'

RSpec.describe 'BooksIndices', type: :request do
  describe 'GET /books_indices' do
    it '非ログイン時でも閲覧可能' do
      get books_path
      expect(response).to have_http_status(:success)
    end
  end
end
