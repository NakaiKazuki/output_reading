require "rails_helper"

RSpec.describe "UsersShows", type: :system do

  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }

  describe "users/:id layout" do
    describe "Users" do
      context "ログインしているユーザーが一致しない場合" do
        it "編集画面へのリンクは存在しない" do
          log_in_by(other_user)
          visit user_path(user)
          expect(current_path).to eq user_path(user)
          expect(page).not_to have_link "登録内容を編集する", href:edit_user_path(user)
        end

        it "新規Bookデータ作成リンクは存在しない" do
          log_in_by(other_user)
          visit user_path(user)
          expect(current_path).to eq user_path(user)
          expect(page).not_to have_link "新しく読んだ本を追加する", href:new_book_path
        end
      end

      context "ログインしているユーザーと一致する場合" do
        it "ユーザー情報編集画面へのリンクが存在する" do
          log_in_by(user)
          visit user_path(user)
          expect(current_path).to eq user_path(user)
          expect(page).to have_link "登録内容を編集する", href:edit_user_path(user), count:1
        end

        it "新規Bookデータ作成リンクが存在する" do
          log_in_by(user)
          visit user_path(user)
          expect(current_path).to eq user_path(user)
          expect(page).to have_link "新しく読んだ本を追加する", href:new_book_path, count:1
        end
      end
    end

    describe "Books" do

      let!(:book) { create(:book,user: user) }
      let!(:other_book) { create(:other_book,user: other_user) }
      let!(:books) { create_list(:books,10,user: user) }

      it "ページネーションで表示されるタイトルは1ページにつき10個まで" do
        log_in_by(user)
        visit user_path(user)
        expect(current_path).to eq user_path(user)
        expect(page).to have_selector ".pagination"
        expect(page).to have_selector ".book-title" ,count:10
      end

      it "他人の投稿はログインしているユーザーのページに表示されない" do
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

      describe "GET edit_book_path" do
        it "他人の投稿編集のリンクは表示されない" do
          log_in_by(user)
          visit user_path(other_user)
          expect(page).not_to have_link "編集", href:edit_book_path(other_book)
        end

        it "自分の投稿編集ページへのリンクは表示される" do
          log_in_by(user)
          visit user_path(user)
          expect(page).to have_link "編集",href:edit_book_path(book)
          find_link("編集",href:edit_book_path(book)).click
          expect(current_path).to eq edit_book_path(book)
        end
      end

      describe "DLETE book_path" do
        it "他人の投稿削除のリンクは表示されない" do
          log_in_by(user)
          visit user_path(other_user)
          expect(page).not_to have_link "削除", href:book_path(other_book)
        end

        it "自分の投稿削除のリンクは表示される" do
          log_in_by(user)
          visit user_path(user)
          expect(page).to have_link "削除",href:book_path(book)
          expect{
            find_link("削除",href: book_path(book)).click
            page.accept_confirm "選択した投稿を削除しますか？（関連する投稿も削除されます。）"
            expect(page).to have_selector ".alert-success"
          }.to change {Book.count}.by(-1)
        end
      end
    end
  end
end
