require "rails_helper"

RSpec.describe "UsersSignups", type: :system do

  describe "signup layout" do

    def submit_with_invalid_information
      fill_in "名前", with: ""
      fill_in "メールアドレス（例：email@example.com）", with: "user@invalid"
      fill_in "パスワード（6文字以上）", with: "foo"
      fill_in "パスワード（再入力）", with: "bar"
      find(".form-submit").click
    end

    def submit_with_valid_information
      fill_in "名前", with: "Example User"
      fill_in "メールアドレス（例：email@example.com）", with: "user@example.com"
      fill_in "パスワード（6文字以上）", with: "password"
      fill_in "パスワード（再入力）", with: "password"
      find(".form-submit").click
    end

    def submit_with_valid_information_if_add_image
      fill_in "名前", with: "Example User"
      fill_in "メールアドレス（例：email@example.com）", with: "user@example.com"
      fill_in "パスワード（6文字以上）", with: "password"
      fill_in "パスワード（再入力）", with: "password"
      attach_file("user_image","spec/fixtures/rails.png")
      find(".form-submit").click
    end

    describe "無効な登録フォーム" do
      it "名前がない場合は無効でフラッシュメッセージが表示される" do
        visit signup_path
        submit_with_invalid_information
        expect(current_path).to eq signup_path
        expect(page).to have_selector ".alert-danger"
        expect(page).to have_selector "#error_explanation"
      end
    end

    describe "有効な登録フォーム" do
      it "入力の条件を満たすため有効" do
        visit signup_path
        submit_with_valid_information
        expect(current_path).to eq root_path
        expect(page).to have_selector '.alert-info'
      end

      it "画像を追加しても入力の条件を満たすため有効" do
        visit signup_path
        submit_with_valid_information_if_add_image
        expect(current_path).to eq root_path
        expect(page).to have_selector '.alert-info'
      end
    end

  end
end
