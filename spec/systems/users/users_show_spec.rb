require "rails_helper"

RSpec.describe "UsersShows", type: :system do

  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }

  describe "users/:id layout" do
    it "ログインしていなくても閲覧可能" do
      visit user_path(user)
      expect(current_path).to eq user_path(user)
    end

    describe "User　Profile" do
      describe "ユーザーがログインしていない場合" do
        it "編集画面へのリンクは存在しない" do
          visit user_path(user)
          expect(current_path).to eq user_path(user)
          expect(page).not_to have_link "登録内容を編集する", href:edit_user_path(user)
        end

        it "フォローボタンは存在しない" do
          visit user_path(user)
          expect(current_path).to eq user_path(user)
          expect(page).not_to have_button "フォロー"
        end
      end

      describe "ログインしているユーザーが一致しない場合" do
        it "編集画面へのリンクは存在しない" do
          log_in_by(other_user)
          visit user_path(user)
          expect(current_path).to eq user_path(user)
          expect(page).not_to have_link "登録内容を編集する", href:edit_user_path(user)
        end

        it "ユーザーの投稿一覧ページへのリンクがある" do
          log_in_by(other_user)
          visit user_path(user)
          expect(current_path).to eq user_path(user)
          expect(page).to have_link "ユーザー投稿一覧", href:user_path(user)
        end

        it "ユーザーのお気に入り投稿リストページへのリンクがある" do
          log_in_by(other_user)
          visit user_path(user)
          expect(current_path).to eq user_path(user)
          expect(page).to have_link "お気に入り投稿一覧", href:favorite_books_user_path(user)
        end

        it "フォローボタンがある" do
          log_in_by(other_user)
          visit user_path(user)
          expect(current_path).to eq user_path(user)
          expect(page).to have_button 'フォロー'
        end

        it "フォローとフォロー解除ボタンが機能している" do
          log_in_by(user)
          visit user_path(other_user)
          expect{
            click_button("フォロー")
            wait_for_ajax
          }.to change {other_user.followers.count}.by(1)
          expect(current_path).to eq user_path(other_user)
          expect{
            click_button("フォロー解除")
            wait_for_ajax
          }.to change {other_user.followers.count}.by(-1)
          expect(current_path).to eq user_path(other_user)
        end
      end

      describe "ログインしているユーザーと一致する場合" do
        it "ユーザー情報編集画面へのリンクが存在する" do
          log_in_by(user)
          visit user_path(user)
          expect(current_path).to eq user_path(user)
          expect(page).to have_link "登録内容を編集する", href:edit_user_path(user), count:1
        end

        it "ユーザーのお気に入り投稿リストページへのリンクがある" do
          log_in_by(user)
          visit user_path(user)
          expect(current_path).to eq user_path(user)
          expect(page).to have_link "お気に入り投稿一覧", href:favorite_books_user_path(user)
        end

        it "フォローボタンは存在しない" do
          log_in_by(user)
          visit user_path(user)
          expect(current_path).to eq user_path(user)
          expect(page).not_to have_button "フォロー"
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

      it "新規Bookデータ作成リンクが存在する" do
        log_in_by(user)
        visit user_path(user)
        expect(current_path).to eq user_path(user)
        expect(page).to have_link "新しい投稿を作成する", href:new_book_path, count:1
      end

      it "一覧のタイトルをクリックで詳細へ移動する" do
        log_in_by(user)
        visit user_path(user)
        expect(current_path).to eq user_path(user)
        find_link(book.title,href: book_path(1)).click
        expect(current_path).to eq book_path(1)
      end

      describe "GET new_book_path" do
        it "ログインしているユーザーが一致しない場合は、新規Bookデータ作成リンクは存在しない" do
          log_in_by(other_user)
          visit user_path(user)
          expect(current_path).to eq user_path(user)
          expect(page).not_to have_link "新新しい投稿を作成する", href:new_book_path
        end

        it "ログインしているユーザーが一致する場合は、新規Bookデータ作成リンクが存在する" do
          log_in_by(user)
          visit user_path(user)
          expect(current_path).to eq user_path(user)
          expect(page).to have_link "新しい投稿を作成する", href:new_book_path, count:1
        end
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
