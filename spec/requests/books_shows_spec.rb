require 'rails_helper'

RSpec.describe "BooksShows", type: :request do

  let(:user) { create(:user) }
  let(:book) { create(:book, user: user) }

  describe "GET /books/:id" do
    it "非ログイン時でも閲覧可能" do
      get books_path
      expect(response).to have_http_status(:success)
    end
  end
end
