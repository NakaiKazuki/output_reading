require 'rails_helper'

RSpec.describe Chapter, type: :model do

  let(:user){ create(:user) }
  let(:book){ create(:book,user: user) }
  let(:chapter){ user.chapters.build(content: "Chapter content",user:user,book: book) }

  describe "Chapter" do
    it "有効" do
      expect(chapter).to be_valid
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
    context "何も入ってない場合は無効" do
      it "存在するべき" do
        chapter.content = nil
        expect(chapter).to be_invalid
      end

      it "2001文字以上は無効" do
        chapter.content = "a" * 2001
        expect(chapter).to be_invalid
      end
    end

    context "有効" do
      it "2000文字までは有効" do
        chapter.content = "a" * 2000
        expect(chapter).to be_valid
      end
    end
  end
end
