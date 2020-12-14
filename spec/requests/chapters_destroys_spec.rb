require 'rails_helper'

RSpec.describe 'ChaptersDestroys', type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }
  let(:book) { create(:book, user: user) }
  let!(:chapter) { create(:chapter, user: user, book: book) }

  describe '無効' do
    it 'ログインしていない時に削除を実行すると、ログイン画面に移動' do
      delete book_chapter_path(book_id: chapter.book_id, number: chapter.number)
      follow_redirect!
      expect(flash[:warning]).to be_truthy
      expect(request.fullpath).to eq '/login'
    end

    it '他人の投稿は削除できない' do
      log_in_as(other_user)
      expect {
        delete book_chapter_path(
          book_id: chapter.book_id,
          number: chapter.number
        )
      }.to change(Chapter, :count).by(0)
      follow_redirect!
      expect(request.fullpath).to eq '/'
    end
  end

  describe '有効' do
    it '投稿者による削除は有効' do
      log_in_as(user)
      expect {
        delete book_chapter_path(
          book_id: chapter.book_id,
          number: chapter.number
        )
      }.to change(Chapter, :count).by(-1)
      follow_redirect!
      expect(flash[:success]).to be_truthy
      expect(request.fullpath).to eq '/books/1'
    end
  end
end
