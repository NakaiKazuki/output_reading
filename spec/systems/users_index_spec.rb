require "rails_helper"

RSpec.describe "UsersIndices", type: :system  do

  let(:admin_add_image) { create(:user,:add_image) }
  let!(:non_admin) { create(:other_user) }

  describe "/users layout" do
    it "ログインしていない状態でアクセス" do
      visit users_path
      expect(current_path).to eq login_path
      expect(page).to have_selector ".alert-warning"
    end

    it "ページネーションで表示されるユーザーは15名" do
      create_list(:users,15)
      log_in_by(admin_add_image)
      visit users_path
      expect(current_path).to eq users_path
      expect(page).to have_selector ".pagination"
      expect(page).to have_selector ".user-name",count:15
    end

    it "一覧の名前をクリックで、そのユーザーのプロフィール画面へ移動" do
      log_in_by(admin_add_image)
      visit users_path
      expect(current_path).to eq users_path
      find_link(admin_add_image.name,href: user_path(admin_add_image)).click
      expect(current_path).to eq user_path(admin_add_image)
    end

    it "ユーザーが画像を設定していれば、設定されている画像を表示する。なければデフォルト画像を表示" do
      log_in_by(admin_add_image)
      visit users_path
      expect(current_path).to eq users_path
      expect(page).to have_selector ".user-image"
      expect(page).to have_selector ".user-image-default"
    end

    context "非管理者としてログイン" do
      it "非管理者としてログインした場合は、一覧内にユーザー削除リンクは表示されない" do
        log_in_by(non_admin)
        visit users_path
        expect(current_path).to eq users_path
        expect(page).not_to have_link "削除",href: user_path(non_admin)
      end
    end

    context "管理者としてログイン" do
      it "管理者としてログインした場合は、非管理者ユーザーの削除リンクが表示される" do
        log_in_by(admin_add_image)
        visit users_path
        expect(current_path).to eq users_path
        expect(page).not_to have_link "削除",href: user_path(admin_add_image)
        expect(page).to have_link non_admin.name,href: user_path(non_admin)
        expect{
          find_link("削除",href: user_path(non_admin)).click
          page.accept_confirm "選択したユーザーを削除しますか？"
          expect(page).to have_selector ".alert-success"
        }.to change {User.count}.by(-1)
        expect(current_path).to eq users_path
        expect(page).not_to have_link non_admin.name,href: user_path(non_admin)
      end
    end
  end
end
