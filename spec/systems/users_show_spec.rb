require "rails_helper"

RSpec.describe "UsersShows", type: :system do

  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }
  let!(:book) { create(:book,user: user) }
  let!(:other_book) { create(:other_book,user: other_user) }
  let!(:books) { create_list(:books,10,user: user) }

  describe "users/:id layout" do
    context "ログインしているユーザーが一致しない場合" do
      it "編集画面へのリンクは存在しない" do
        log_in_by(other_user)
        visit user_path(user)
        expect(current_path).to eq user_path(user)
        expect(page).not_to have_link "登録内容を編集する", href:edit_user_path(user)
      end
    end

    context "ログインしているユーザーと一致する場合" do
      it "編集画面へのリンクが存在する" do
        log_in_by(user)
        visit user_path(user)
        expect(current_path).to eq user_path(user)
        expect(page).to have_link "登録内容を編集する", href:edit_user_path(user), count:1
      end
    end

    describe "books layout in /users/:id" do
      it "ページネーションで表示されるタイトルは1ページにつき10個まで" do
        log_in_by(user)
        visit user_path(user)
        expect(current_path).to eq user_path(user)
        expect(page).to have_selector ".pagination"
        expect(page).to have_selector ".book-title" ,count:10
      end

      it "他人の投稿は表示されない" do
        log_in_by(user)
        visit user_path(user)
        expect(current_path).to eq user_path(user)
        expect(page).not_to have_link other_book.title ,href:book_path(other_book)
      end

      it "一覧のタイトルをクリックで詳細へ移動する" do
        log_in_by(user)
        visit user_path(user)
        expect(current_path).to eq user_path(user)
        find_link(book.title,href: book_path(1)).click
        expect(current_path).to eq book_path(1)
      end
    end
  end
end
