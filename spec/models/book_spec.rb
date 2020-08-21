require 'rails_helper'

RSpec.describe Book, type: :model do
  let(:user){ create(:user) }
  let(:book){ user.books.create(title: "Book title",user:user) }

  describe "Book" do
    it "有効" do
      expect(book).to be_valid
    end

    it "新しいものが最初に来る" do
      create(:book, user: user, created_at: 10.minutes.ago)
      create(:book_2, user: user, created_at: 3.years.ago)
      create(:book_3, user: user, created_at: 2.hours.ago)
      book_4 = create(:book_4,user: user, created_at: Time.zone.now)
      expect(Book.first).to eq book_4
    end
  end

  describe "user_id" do
    it "何も入ってない場合は無効" do
      book.user_id = nil
      expect(book).to be_invalid
    end
  end

  describe "title" do
    describe "何も入ってない場合は無効" do
      it "存在するべき" do
        book.title = nil
        expect(book).to be_invalid
      end

      it "51文字以上は無効" do
        book.title = "a" * 51
        expect(book).to be_invalid
      end
    end

    describe "有効" do
      it "50文字までは有効" do
        book.title = "a" * 50
        expect(book).to be_valid
      end
    end
  end

  describe "アソシエーション"do
    it "Bookデータ削除時に紐づいたChapterのデータを削除" do
      user.chapters.create(content: "Chapter content",number:1,user: user,book: book)
      expect{ book.destroy }.to change{ Chapter.count }.by(-1)
    end

    it "Bookデータ削除時に紐づいたFavoriteのデータ削除" do
      user.favorites.create(user:user,book:book)
      expect{ book.destroy }.to change{ Favorite.count }.by(-1)
    end
  end
end
