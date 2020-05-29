require "rails_helper"

RSpec.describe "UsersIndices", type: :system  do

  let!(:admin_add_image) { create(:user,:add_image) }
  let!(:non_admin) { create(:other_user) }
  let!(:users) { create_list(:users,15) }

  describe "/users layout" do
    it "ログインしていない状態でアクセス" do
      visit users_path
      expect(current_path).to eq login_path
      expect(page).to have_selector ".alert-warning"
    end

    it "ページネーションで表示されるユーザーは15名" do
      log_in_by(admin_add_image)
      visit users_path
      expect(current_path).to eq users_path
      expect(page).to have_selector ".pagination"
      expect(page).to have_selector ".users-index-name",count:15
    end

    context "管理者としてログイン" do
      it "管理者としてログインしユーザー一覧を表示した場合は、
          一覧内に非管理者ユーザーの削除リンクが表示される" do
        log_in_by(admin_add_image)
        visit users_path
        expect(current_path).to eq users_path
        expect(page).not_to have_link "削除",href: user_path(admin_add_image)
        expect(page).to have_link non_admin.name,href: user_path(non_admin)
        find_link("削除",href: user_path(non_admin)).click
        expect{
          page.accept_confirm "選択したユーザーを削除しますか？"
          expect(page).to have_selector ".alert-success"
        }.to change {User.count}.by(-1)
        expect(current_path).to eq users_path
        expect(page).not_to have_link non_admin.name,href: user_path(non_admin)
      end
    end

    context "非管理者としてログイン" do
      it "非管理者としてログインした場合は、一覧内にユーザー削除リンクは表示されない。
          もしユーザーが画像を設定していれば、設定されている画像を表示する" do
        log_in_by(non_admin)
        visit users_path
        expect(current_path).to eq users_path
        expect(page).to have_selector ".user-image"
        expect(page).to have_selector ".user-image-default"
        expect(page).not_to have_link "削除",href: user_path(non_admin)
      end
    end
  end
end
