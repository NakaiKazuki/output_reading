require "rails_helper"

RSpec.describe "UsersIndices", type: :system  do
include SessionsHelper

  let!(:admin_add_image) { create(:user_add_image) }
  let!(:non_admin) { create(:other_user) }
  let!(:users) { create_list(:users,10) }

  describe "/users layout" do
    it "index as admin including pagination and delete links" do
      log_in_by(admin_add_image)
      visit users_path
      expect(page).to have_selector ".users-index-container"
      expect(page).to have_selector ".pagination"
      expect(page).to have_selector ".users-index-name",count:10
      expect(page).not_to have_link "削除",href: user_path(admin_add_image)
      expect(page).to have_link non_admin.name,href: user_path(non_admin)
      find_link("削除",href: user_path(non_admin)).click
      expect{
        page.accept_confirm "選択したユーザーを削除しますか？"
        expect(page).to have_selector ".alert-success"
      }.to change {User.count}.by(-1)
      expect(page).to have_selector ".users-index-container"
      expect(page).not_to have_link non_admin.name,href: user_path(non_admin)
    end

    it "log in as a non-administrator, there is no delete link.
        If the image is set by the user, it will be displayed." do
      log_in_by(non_admin)
      visit users_path
      expect(page).to have_selector ".users-index-container"
      expect(page).to have_selector ".pagination"
      expect(page).to have_selector ".users-index-name",count:10
      expect(page).to have_selector ".user-image"
      expect(page).to have_selector ".user-image-default"
      expect(page).not_to have_link "削除",href: user_path(non_admin)
    end

  end
end
