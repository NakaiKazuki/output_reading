require "rails_helper"

RSpec.describe "UsersFavoritesBooks", type: :system  do
  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }

  describe "users/:id/favorite_books layout" do
    it "ログインしていなくても閲覧可能" do
      visit favorite_books_user_path(user)
      expect(current_path).to eq favorite_books_user_path(user)
    end

    describe "User　Profile" do
      describe "ユーザーがログインしていない場合" do
        it "編集画面へのリンクは存在しない" do
          visit favorite_books_user_path(user)
          expect(current_path).to eq favorite_books_user_path(user)
          expect(page).not_to have_link "登録内容を編集する", href:edit_user_path(user)
        end

        it "フォローボタンは存在しない" do
          visit favorite_books_user_path(user)
          expect(current_path).to eq favorite_books_user_path(user)
          expect(page).not_to have_button "フォロー"
        end
      end

      describe "ログインしているユーザーが一致しない場合" do
        it "編集画面へのリンクは存在しない" do
          log_in_by(other_user)
          visit favorite_books_user_path(user)
          expect(current_path).to eq favorite_books_user_path(user)
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
          visit favorite_books_user_path(user)
          expect(current_path).to eq favorite_books_user_path(user)
          expect(page).to have_link "お気に入り投稿一覧", href:favorite_books_user_path(user)
        end

        it "フォローとフォロー解除ボタンが機能している",js:true do
          log_in_by(other_user)
          visit favorite_books_user_path(user)
          expect{
            click_button("フォロー")
            wait_for_ajax
          }.to change {Relationship.count}.by(1)
          expect(current_path).to eq favorite_books_user_path(user)
          expect{
            click_button("フォロー解除")
            wait_for_ajax
          }.to change {Relationship.count}.by(-1)
          expect(current_path).to eq favorite_books_user_path(user)
        end
      end

      describe "ログインしているユーザーと一致する場合" do
        it "ユーザー情報編集画面へのリンクが存在する" do
          log_in_by(user)
          visit favorite_books_user_path(user)
          expect(current_path).to eq favorite_books_user_path(user)
          expect(page).to have_link "登録内容を編集する", href:edit_user_path(user), count:1
        end

        it "ユーザーのお気に入り投稿リストページへのリンクがある" do
          log_in_by(user)
          visit favorite_books_user_path(user)
          expect(current_path).to eq favorite_books_user_path(user)
          expect(page).to have_link "お気に入り投稿一覧", href:favorite_books_user_path(user)
        end

        it "フォローボタンは存在しない" do
          log_in_by(user)
          visit favorite_books_user_path(user)
          expect(current_path).to eq favorite_books_user_path(user)
          expect(page).not_to have_button "フォロー"
        end
      end
    end

    describe "Favorite Books" do
      describe "お気に入り投稿がない場合" do
        it "投稿無しと表示される" do
          log_in_by(user)
          visit favorite_books_user_path(user)
          expect(current_path).to eq favorite_books_user_path(user)
          expect(page).to have_selector ".non-item"
        end
      end

      describe "お気に入り投稿がある場合" do

        let(:book) { create(:book,:add_image,user: user) }
        let!(:favorite) { create(:favorite,user:user,book:book) }

        it "お気に入り投稿詳細へのリンクがある" do
          log_in_by(user)
          visit favorite_books_user_path(user)
          expect(current_path).to eq favorite_books_user_path(user)
          expect(page).to have_link book.title,href:book_path(book)
        end

        it "お気に入り投稿に画像があれば表示する" do
          log_in_by(user)
          visit favorite_books_user_path(user)
          expect(current_path).to eq favorite_books_user_path(user)
          expect(page).to have_selector ".book-image"
        end
      end
    end
  end
end
