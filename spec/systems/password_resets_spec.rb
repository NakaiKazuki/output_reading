require "rails_helper"

RSpec.describe "PasswordResets", type: :system do

  before do
    ActionMailer::Base.deliveries.clear
  end

  let(:user){ create(:user) }

  def visit_edit_password_reset
    visit new_password_reset_path
    fill_in "メールアドレス", with: user.email
    find(".form-submit").click
    open_email("user@example.com")
    current_email.click_link 'パスワードを再設定する'
  end

  describe "/password_resets/new layout" do
    it "無効なメールアドレス" do
      visit new_password_reset_path
      expect(current_path).to eq new_password_reset_path
      fill_in "メールアドレス", with: ""
      expect{
        find(".form-submit").click
        expect(page).to have_selector ".alert-danger"
      }.to change {ActionMailer::Base.deliveries.size }.by(0)
      expect(current_path).to eq "/password_resets"
      expect(page).to have_selector ".password_reset_new-container"
    end

    it "有効なメールアドレス" do
      visit new_password_reset_path
      expect(current_path).to eq new_password_reset_path
      fill_in "メールアドレス", with: user.email
      expect{
        find(".form-submit").click
        expect(page).to have_selector ".alert-info"
      }.to change { ActionMailer::Base.deliveries.size }.by(1)
      expect(current_path).to eq root_path
    end
  end

  describe "/password_resets/:id/edit layout" do

    it "有効期限の過ぎたreset_tokenは無効" do
      visit new_password_reset_path
      fill_in "メールアドレス", with: user.email
      find(".form-submit").click
      user.update_attribute(:reset_sent_at, 3.hours.ago)
      open_email("user@example.com")
      current_email.click_link 'パスワードを再設定する'
      expect(current_path).to eq new_password_reset_path
      expect(page).to have_selector ".alert-danger"
    end

    it "有効なリンク" do
      visit new_password_reset_path
      fill_in "メールアドレス", with: user.email
      find(".form-submit").click
      open_email("user@example.com")
      current_email.click_link 'パスワードを再設定する'
      expect(page).to have_selector ".password_reset_edit-container"
    end
  end

  describe "PATCH /password_resets/:id" do
    context "無効" do
      it "無効なパスワード" do
        visit_edit_password_reset
        fill_in "パスワード（6文字以上）",with: "foobaz"
        fill_in "パスワード（再入力）" , with: "barquux"
        find(".form-submit").click
        expect(page).to have_selector ".password_reset_edit-container"
      end

      it "空のパスワード" do
        visit_edit_password_reset
        fill_in "パスワード（6文字以上）",with: ""
        fill_in "パスワード（再入力）" , with: ""
        find(".form-submit").click
        expect(page).to have_selector ".password_reset_edit-container"
      end
    end

    context "有効" do
      it "有効な情報" do
        visit_edit_password_reset
        fill_in "パスワード（6文字以上）",with: "foobar"
        fill_in "パスワード（再入力）" , with: "foobar"
        find(".form-submit").click
        expect(current_path).to eq user_path(user)
        expect(page).to have_selector ".alert-success"
      end
    end
  end
end
