require "rails_helper"

RSpec.describe "AccountActivations", type: :system do

  before do
    ActionMailer::Base.deliveries.clear
  end

  def user_create
    visit signup_path
    fill_in "名前", with: "Example User"
    fill_in "メールアドレス（例：email@example.com）", with: "user@example.com"
    fill_in "パスワード（6文字以上）", with: "password"
    fill_in "パスワード（再入力）", with: "password"
    find(".form-submit").click
  end

  it "is valid when first authentication" do
    expect{
      user_create
      expect(page).to have_selector '.alert-info'
      }.to change{ ActionMailer::Base.deliveries.size }.by(1)
    expect(current_path).to eq root_path
    open_email("user@example.com")
    current_email.click_link '認証する'
    expect(page).to have_selector ".alert-success"
    expect(current_path).to eq "/users/1"
  end

  it "is invalid when second authentication" do
    expect{
      user_create
      }.to change{ ActionMailer::Base.deliveries.size }.by(1)
    open_email("user@example.com")
    current_email.click_link '認証する'
    expect(current_path).to eq "/users/1"
    current_email.click_link '認証する'
    expect(page).to have_selector ".alert-danger"
    expect(current_path).to eq "/"
  end
end
