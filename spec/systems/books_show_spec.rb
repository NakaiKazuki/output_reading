require "rails_helper"

RSpec.describe "BooksShows", type: :system  do
  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }
  let(:book) { create(:book,user: user) }
  let(:other_book) { create(:book_2,user: user)}
  let!(:chapter) { create(:chapter,user: user,book: book) }
  let!(:other_book_chapter) { create(:other_book_chapter,user: user,book: other_book) }

  describe  "/book/:id layout" do
    context "非ログイン状態(共通)" do
      it "ログインしていなくてもアクセス可能" do
        visit book_path(book)
        expect(current_path).to eq book_path(book)
      end

      it "別のBookデータに紐づいたデータは投稿者が同じでも表示されない" do
        visit book_path(book)
        expect(chapter.user_id).to eq other_book_chapter.user_id
        expect(page).to have_selector ".chapter-content",text: chapter.content
        expect(page).not_to have_selector ".chapter-content",text: other_book_chapter.content
      end

      # it "投稿の編集と削除のリンクは表示されない" do
      #   visit book_path(book)
      #   expect(page).not_to have_link "編集",href: edit_chapter_path(chapter)
      #   expect(page).not_to have_link "削除",href: chapter_path(chapter)
      # end

      describe "ページネーション" do
        let!(:chapters) { create_list(:chapters,16,user: user,book: book) }
        it "表示される投稿数は1ページ15個まで" do
          visit book_path(book)
          expect(page).to have_selector ".chapter-content",count:15
        end
      end
    end

    # context "別のユーザーとしてログイン" do
    #   before do
    #     log_in_by(other_user)
    #   end
    #
    #   it "他のユーザーの投稿には編集と削除のリンクは表示されない" do
    #     visit book_path(book)
    #     expect(page).not_to have_link "編集",href: editchapter_path(chapter)
    #     expect(page).not_to have_link "削除",href: chapter_path(chapter)
    #   end
    # end
  end
end
