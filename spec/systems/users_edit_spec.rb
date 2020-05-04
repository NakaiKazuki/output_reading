require 'rails_helper'

RSpec.describe "UsersEdits", type: :system do

  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }


  def submit_with_invalid_information
    fill_in '名前', with: ''
    fill_in 'メールアドレス（例：email@example.com）', with: 'user@invalid'
    fill_in 'パスワード（6文字以上）', with: 'foo'
    fill_in 'パスワード（再入力）', with: 'bar'
    find(".form-submit").click
  end

  def submit_with_valid_information
    fill_in '名前', with: 'Foo Bar'
    fill_in 'メールアドレス（例：email@example.com）', with: 'foo@bar.com'
    fill_in 'パスワード（6文字以上）', with: 'password'
    fill_in 'パスワード（再入力）', with: 'password'
    find(".form-submit").click
  end

  def submit_as_valid_information_even_if_password_is_empty
    fill_in '名前', with: 'Foo Bar'
    fill_in 'メールアドレス（例：email@example.com）', with: 'foo@bar.com'
    fill_in 'パスワード（6文字以上）', with: ''
    fill_in 'パスワード（再入力）', with: ''
    find(".form-submit").click
  end

  describe "users/:id/edit layout" do

    context "user is not logged in" do
      it "is invalid getting edit_user_path" do
        visit edit_user_path(user)
        expect(page).to have_selector '.alert-warning'
        expect(page).to have_selector '.login-container'
      end
    end

    context "access by other users" do
      it "can't get edit_user_path of others." do
        log_in_by(other_user)
        expect(page).to have_selector '.show-container'
        visit edit_user_path(user)
        expect(page).not_to have_selector '.edit-container'
        expect(page).to have_selector '.home-container'
      end
    end

    context "matching user" do
      context "invalid edit form" do
        it "is invalid information" do
          log_in_by(user)
          visit edit_user_path(user)
          expect(current_path).to eq edit_user_path(user)
          submit_with_invalid_information
          expect(current_path).to eq user_path(user)
          expect(page).to have_selector '.edit-container'
          expect(page).to have_selector '.alert-danger'
          expect(page).to have_selector '#error_explanation'
        end
      end

      context "valid edit form" do
        it "is valid information" do
          log_in_by(user)
          visit edit_user_path(user)
          expect(current_path).to eq edit_user_path(user)
          submit_with_valid_information
          expect(current_path).to eq user_path(user)
          expect(page).to have_selector '.show-container'
          expect(page).to have_selector '.alert-success'
          expect(page).not_to have_selector '#error_explanation'
        end

        it "is valid information even if the password is empty" do
          log_in_by(user)
          visit edit_user_path(user)
          expect(current_path).to eq edit_user_path(user)
          submit_as_valid_information_even_if_password_is_empty
          expect(user.reload.name).to eq 'Foo Bar'
          expect(user.reload.password).to eq 'password'
          expect(current_path).to eq user_path(user)
          expect(page).to have_selector '.show-container'
          expect(page).to have_selector '.alert-success'
          expect(page).not_to have_selector '#error_explanation'
        end
      end
    end

    it "was a request as the correct user, so move to the previous link" do
      visit edit_user_path(user)
      expect(page).to have_selector '.login-container'
      log_in_by(user)
      expect(page).to have_selector '.edit-container'
    end

  end

end
