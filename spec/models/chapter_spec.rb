require 'rails_helper'

RSpec.describe Chapter, type: :model do

  let(:user){ create(:user) }
  let(:book){ create(:book,user: user) }
  let(:chapter){ user.chapters.build(content: "Chapter content",number:1,user:user,book: book) }

  describe "Chapter" do
    it "有効" do
      expect(chapter).to be_valid
    end
  end

  describe "number" do
    it "何も入ってない場合は無効" do
      chapter.number = nil
      expect(chapter).to be_invalid
    end

    it "数値以外は無効" do
      chapter.number = "number"
      expect(chapter).to be_invalid
    end

    it "一つの本にある章番号は一意であるべき" do
      user.chapters.create(number:1,content:"Chapter content",user:user,book:book)
      chapter_2 = user.chapters.build(content: "Chapter content_2",number:1,user:user,book: book)
      expect(chapter_2).to be_invalid
    end
  end

  describe "user_id" do
    it "何も入ってない場合は無効" do
      chapter.user_id = nil
      expect(chapter).to be_invalid
    end
  end

  describe "book_id" do
    it "何も入ってない場合は無効" do
      chapter.book_id = nil
      expect(chapter).to be_invalid
    end
  end

  describe "content" do
    describe "何も入ってない場合は無効" do
      it "空は無効" do
        chapter.content = nil
        expect(chapter).to be_invalid
      end

      it "4001文字以上は無効" do
        chapter.content = "a" * 4001
        expect(chapter).to be_invalid
      end
    end

    describe "有効" do
      it "4000文字までは有効" do
        chapter.content = "a" * 4000
        expect(chapter).to be_valid
      end
    end
  end
end
