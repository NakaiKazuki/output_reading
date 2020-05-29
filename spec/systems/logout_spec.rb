require "rails_helper"

RSpec.describe "Logouts", type: :system do
  let(:user) { create(:user) }

  def submit_with_valid_information(remember_me = 0)
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: user.password
    check "session_remember_me" if remember_me == 1
    find(".form-submit").click
  end

  describe "Logout" do

    it "contains login button without logout button at root path" do
      visit login_path
      submit_with_valid_information
      expect(current_path).to eq user_path(1)
      expect(page).to have_selector ".btn-logout-extend"
      expect(page).not_to have_selector ".btn-login-extend"
      click_on "ログアウト"
      expect(current_path).to eq root_path
      expect(page).to have_selector ".btn-login-extend"
      expect(page).not_to have_selector ".btn-logout-extend"
    end
  end
end
