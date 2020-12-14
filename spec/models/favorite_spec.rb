require 'rails_helper'

RSpec.describe Favorite, type: :model do
  let(:user) { create(:user) }
  let(:book) { create(:book, user: user) }
  let(:favorite) { user.favorites.build(user: user, book: book) }

  describe 'Favorite' do
    it '有効' do
      expect(favorite).to be_valid
    end
  end

  describe '無効' do
    it 'user_idが空は無効' do
      favorite.user_id = nil
      expect(favorite).to be_invalid
    end

    it 'book_idが空は無効' do
      favorite.book_id = nil
      expect(favorite).to be_invalid
    end

    it 'user_idとbook_idの組み合わせは一意' do
      user.favorites.create(user: user, book: book)
      favorite2 = user.favorites.build(user: user, book: book)
      expect(favorite2).to be_invalid
    end
  end
end
