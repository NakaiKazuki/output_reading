require 'rails_helper'

RSpec.describe "UsersSignups", type: :system do

  describe "signup layout" do

    def submit_with_invalid_information
      fill_in '名前', with: ''
      fill_in 'メールアドレス（例：email@example.com）', with: 'user@invalid'
      fill_in 'パスワード（6文字以上）', with: 'foo'
      fill_in 'パスワード（再入力）', with: 'bar'
      find(".form-submit").click
    end

    def submit_with_valid_information
      fill_in '名前', with: 'Example User'
      fill_in 'メールアドレス（例：email@example.com）', with: 'user@example.com'
      fill_in 'パスワード（6文字以上）', with: 'password'
      fill_in 'パスワード（再入力）', with: 'password'
      find(".form-submit").click
    end

    context "invalid signup form" do
      it "is invalid because it has no name" do
        visit signup_path
        submit_with_invalid_information
        expect(current_path).to eq signup_path
        expect(page).to have_selector "#error_explanation"
      end
    end

    context "valid signup form" do
      it "is valid because it fulfils condition of input" do
        visit signup_path
        submit_with_valid_information
        expect(current_path).to eq user_path(1)
        expect(page).not_to have_selector "#error_explanation"
      end
    end

  end
end
