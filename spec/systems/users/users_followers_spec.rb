require "rails_helper"

RSpec.describe "UsersFollowers", type: :system  do
  let(:user) { create(:user) }
  let(:other_user) { create(:other_user,:add_image) }

  describe "users/:id/followers layout" do
    it "ログインしていなくても閲覧可能" do
      visit followers_user_path(user)
      expect(current_path).to eq followers_user_path(user)
    end

    describe "User　Profile" do
      describe "ユーザーがログインしていない場合" do
        it "編集画面へのリンクは存在しない" do
          visit followers_user_path(user)
          expect(current_path).to eq followers_user_path(user)
          expect(page).not_to have_link "登録内容を編集する", href:edit_user_path(user)
        end

        it "フォローボタンは存在しない" do
          visit followers_user_path(user)
          expect(current_path).to eq followers_user_path(user)
          expect(page).not_to have_button "フォロー"
        end
      end

      describe "ログインしているユーザーが一致しない場合" do
        it "編集画面へのリンクは存在しない" do
          log_in_by(other_user)
          visit followers_user_path(user)
          expect(current_path).to eq followers_user_path(user)
          expect(page).not_to have_link "登録内容を編集する", href:edit_user_path(user)
        end

        it "ユーザーの投稿一覧ページへのリンクがある" do
          log_in_by(other_user)
          visit followers_user_path(user)
          expect(current_path).to eq followers_user_path(user)
          expect(page).to have_link "ユーザー投稿一覧", href:user_path(user)
        end

        it "ユーザーのお気に入り投稿リストページへのリンクがある" do
          log_in_by(other_user)
          visit followers_user_path(user)
          expect(current_path).to eq followers_user_path(user)
          expect(page).to have_link "お気に入り投稿一覧", href:favorite_books_user_path(user)
        end

        it "フォローボタンがある" do
          log_in_by(other_user)
          visit followers_user_path(user)
          expect(current_path).to eq followers_user_path(user)
          expect(page).to have_button 'フォロー'
        end

        it "フォローとフォロー解除ボタンが機能している" do
          log_in_by(user)
          visit followers_user_path(other_user)
          expect{
            click_button("フォロー")
            wait_for_ajax
          }.to change {other_user.followers.count}.by(1)
          expect(current_path).to eq followers_user_path(other_user)
          expect{
            click_button("フォロー解除")
            wait_for_ajax
          }.to change {other_user.followers.count}.by(-1)
          expect(current_path).to eq followers_user_path(other_user)
        end
      end

      describe "ログインしているユーザーと一致する場合" do
        it "ユーザー情報編集画面へのリンクが存在する" do
          log_in_by(user)
          visit followers_user_path(user)
          expect(current_path).to eq followers_user_path(user)
          expect(page).to have_link "登録内容を編集する", href:edit_user_path(user), count:1
        end

        it "ユーザーのお気に入り投稿リストページへのリンクがある" do
          log_in_by(user)
          visit followers_user_path(user)
          expect(current_path).to eq followers_user_path(user)
          expect(page).to have_link "お気に入り投稿一覧", href:favorite_books_user_path(user)
        end

        it "フォローボタンは存在しない" do
          log_in_by(user)
          visit followers_user_path(user)
          expect(current_path).to eq followers_user_path(user)
          expect(page).not_to have_button "フォロー"
        end
      end
    end

    describe "Show_Follow" do

      let!(:relationship){ create(:relationship,follower: other_user,followed: user) }

      describe "ユーザーがログインしていない場合" do
        it "一覧の名前をクリックで、そのユーザーのプロフィール画面へ移動" do
          visit followers_user_path(user)
          expect(current_path).to eq followers_user_path(user)
          find_link(other_user.name,href: user_path(other_user)).click
          expect(current_path).to eq user_path(other_user)
        end

        it "ユーザーが画像を設定していれば、設定されている画像を表示する。なければデフォルト画像を表示" do
          visit followers_user_path(user)
          expect(current_path).to eq followers_user_path(user)
          expect(page).to have_selector ".user-image",count:1
          expect(page).to have_selector ".user-image-default",count:1
        end
      end

      describe "ユーザーがログインしている場合" do
        it "一覧の名前をクリックで、そのユーザーのプロフィール画面へ移動" do
          log_in_by(user)
          visit followers_user_path(user)
          expect(current_path).to eq followers_user_path(user)
          find_link(other_user.name,href: user_path(other_user)).click
          expect(current_path).to eq user_path(other_user)
        end

        it "ユーザーが画像を設定していれば、設定されている画像を表示する。なければデフォルト画像を表示" do
          log_in_by(user)
          visit followers_user_path(user)
          expect(current_path).to eq followers_user_path(user)
          expect(page).to have_selector ".user-image",count:1
          expect(page).to have_selector ".user-image-default",count:1
        end
      end
    end
  end
end
