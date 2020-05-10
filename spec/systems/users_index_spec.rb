require "rails_helper"

RSpec.describe "UsersIndices", type: :system  do
include SessionsHelper
  let!(:admin_add_image) { create(:user_add_image) }
  let!(:non_admin) { create(:other_user) }
  let!(:users) { create_list(:users,9) }

  describe "/users layout" do
    it "index as admin including pagination and delete links" do
      log_in_by(admin_add_image)
      visit users_path
      expect(page).to have_selector ".users-index-container"
      expect(page).to have_selector ".pagination"
      expect(page).not_to have_link "削除",href: user_path(admin_add_image)
      #コントローラーで @usersがここでのfirst_page_of_users
      first_page_of_users =  User.page(1).per(10)
      first_page_of_users.each do |user|
        expect(page).to have_link user.name ,href: user_path(user)
        expect(page).to have_link "削除",href: user_path(user) unless user == admin_add_image
      end
    end
    #User.page(1).per(10)が無くても書けるようになるのが課題。今はシラネ

    it "Index as non-admin show if image is registered by user" do
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
