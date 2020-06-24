require "rails_helper"

RSpec.describe "Logouts", type: :system do
  let(:user) { create(:user) }

  describe "Logout" do
    it "ログイン時にはログインボタンはなくログアウトボタンが表示される" do
      log_in_by(user)
      expect(page).to have_selector ".btn-logout-extend"
      expect(page).not_to have_selector ".btn-login-extend"
      click_on "ログアウト"
      expect(current_path).to eq root_path
      expect(page).to have_selector ".btn-login-extend"
      expect(page).not_to have_selector ".btn-logout-extend"
    end
  end
end
