require "rails_helper"

RSpec.describe "PasswordResets", type: :system do

  before do
    ActionMailer::Base.deliveries.clear
  end

  let(:user){ create(:user) }

  def visit_password_resets_edit
    visit new_password_reset_path
    fill_in "メールアドレス", with: user.email
    find(".form-submit").click
    open_email("user@example.com")
    current_email.click_link 'パスワードを再設定する'
  end

  describe "/password_resets/new layout" do
    it "is invalid email address " do
      visit new_password_reset_path
      expect(page).to have_selector ".password_reset_new-container"
      fill_in "メールアドレス", with: ""
      expect{
        find(".form-submit").click
        expect(page).to have_selector ".alert-danger"
      }.to change {ActionMailer::Base.deliveries.size }.by(0)
      expect(page).to have_selector ".password_reset_new-container"
    end

    it "is valid email address" do
      visit new_password_reset_path
      expect(page).to have_selector ".password_reset_new-container"
      fill_in "メールアドレス", with: user.email
      expect{
        find(".form-submit").click
        expect(page).to have_selector ".alert-info"
      }.to change { ActionMailer::Base.deliveries.size }.by(1)
      expect(page).to have_selector ".home-container"
    end
  end

  describe "/password_resets/:id/edit layout" do

    it "move by clicking the link in the email" do
      visit new_password_reset_path
      fill_in "メールアドレス", with: user.email
      find(".form-submit").click
      open_email("user@example.com")
      current_email.click_link 'パスワードを再設定する'
      expect(page).to have_selector ".password_reset_edit-container"
    end
  end

  describe "PATCH /password_resets/:id" do
    context "invalid" do
      it "is invalid password" do
        visit_password_resets_edit
        fill_in "パスワード（6文字以上）",with: "foobaz"
        fill_in "パスワード（再入力）" , with: "barquux"
        find(".form-submit").click
        expect(page).to have_selector ".password_reset_edit-container"
      end

      it "is empty password" do
        visit_password_resets_edit
        fill_in "パスワード（6文字以上）",with: ""
        fill_in "パスワード（再入力）" , with: ""
        find(".form-submit").click
        expect(page).to have_selector ".password_reset_edit-container"
      end
    end

    context "valid" do
      it "is valid information" do
        visit_password_resets_edit
        fill_in "パスワード（6文字以上）",with: "foobar"
        fill_in "パスワード（再入力）" , with: "foobar"
        find(".form-submit").click
        expect(page).to have_selector ".alert-success"
        expect(page).to have_selector ".show-container"
      end
    end
  end

end
