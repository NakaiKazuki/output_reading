require "rails_helper"

RSpec.describe "UsersIndices", type: :system  do

  let!(:user) { create(:user_add_image) }
  let!(:other_user) { create(:other_user) }
  let!(:users) { create_list(:users,15) }

  describe "/users layout" do
    it "index including pagination" do
      log_in_by(user)
      visit users_path
      expect(page).to have_selector ".users-index-container"
      expect(page).to have_selector ".user-image"
      expect(page).to have_selector ".user-image-default"
      expect(page).to have_link user.name , href: user_path(user)
      expect(page).to have_link other_user.name , href: user_path(other_user)
      expect(page).to have_selector ".pagination"
    end
  end
end
