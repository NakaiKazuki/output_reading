require 'rails_helper'

RSpec.describe 'AccountActivations', type: :system do
  before do
    ActionMailer::Base.deliveries.clear
  end

  def user_create
    visit signup_path
    fill_in '名前', with: 'Example User'
    fill_in 'メールアドレス（例：email@example.com）', with: 'user@example.com'
    fill_in 'パスワード（6文字以上）', with: 'password'
    fill_in 'パスワード（再入力）', with: 'password'
    find('.form-submit').click
  end

  it '最初の認証は有効' do
    expect {
      user_create
      expect(page).to have_selector '.alert-info'
    }.to change { ActionMailer::Base.deliveries.size }.by(1)
    expect(page).to have_current_path root_path, ignore_query: true
    open_email('user@example.com')
    current_email.click_link '認証する'
    expect(page).to have_selector '.alert-success'
    expect(page).to have_current_path user_path(1), ignore_query: true
  end

  it '認証後さらに認証は無効' do
    expect {
      user_create
    }.to change { ActionMailer::Base.deliveries.size }.by(1)
    open_email('user@example.com')
    current_email.click_link '認証する'
    expect(page).to have_current_path user_path(1), ignore_query: true
    current_email.click_link '認証する'
    expect(page).to have_selector '.alert-danger'
    expect(page).to have_current_path root_path, ignore_query: true
  end
end
