require 'rails_helper'

RSpec.describe "Logins", type: :system do
  let(:user) { create(:user) }

  describe "Login" do
    context "invalid" do
      it "is invalid because it has no information" do
        visit login_path
        expect(page).to have_selector ".login-container"
        fill_in "メールアドレス", with: ""
        fill_in "パスワード", with: ""
        find(".form-submit").click
        expect(current_path).to eq login_path
        expect(page).to have_selector ".login-container"
        expect(page).to have_selector ".alert-danger"
      end

      it "deletes flash messages when users input invalid information" do
        visit login_path
        expect(page).to have_selector ".login-container"
        fill_in "メールアドレス", with: ""
        fill_in "パスワード", with: ""
        find(".form-submit").click
        expect(current_path).to eq login_path
        expect(page).to have_selector ".login-container"
        expect(page).to have_selector ".alert-danger"
        visit root_path
        expect(page).not_to have_selector ".alert-danger"
      end
    end

    context "valid" do
      it "is valid because it has information"do
        visit login_path
        expect(page).to have_selector ".login-container"
        fill_in "メールアドレス", with: user.email
        fill_in "パスワード", with: "foobar"
        find(".form-submit").click
        expect(current_path).to eq user_path(1)
        expect(page).to have_selector ".show-container"
      end

      it "contains logout button without login button"do
        visit login_path
        expect(page).to have_selector ".login-container"
        fill_in "メールアドレス", with: user.email
        fill_in "パスワード", with: "foobar"
        find(".form-submit").click
        expect(current_path).to eq user_path(1)
        expect(page).to have_selector ".show-container"
        expect(page).to have_link "ログアウト", href: logout_path
        expect(page).not_to have_link "ログイン", href: login_path
      end
    end
  end

  describe "Logout" do
    it "contains login button without logout button" do
      visit login_path
      expect(page).to have_selector ".login-container"
      fill_in "メールアドレス", with: user.email
      fill_in "パスワード", with: "foobar"
      find(".form-submit").click
      expect(current_path).to eq user_path(1)
      expect(page).to have_selector ".show-container"
      expect(page).to have_link "ログアウト", href: logout_path
      expect(page).not_to have_link "ログイン", href: login_path
      click_on "ログアウト"
      expect(current_path).to eq root_path
      expect(page).to have_link "ログイン", href: login_path
      expect(page).not_to have_link "ログアウト", href: logout_path
    end
  end
end
