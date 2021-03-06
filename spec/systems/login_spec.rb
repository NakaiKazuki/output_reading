require 'rails_helper'

RSpec.describe 'Logins', type: :system do
  let(:user) { create(:user) }

  def submit_with_invalid_information
    fill_in 'メールアドレス', with: ''
    fill_in 'パスワード', with: ''
    find('.form-submit').click
  end

  def submit_with_valid_information(remember_me = 0)
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: user.password
    check 'session_remember_me' if remember_me == 1
    find('.form-submit').click
  end

  describe '/login layout' do
    describe '無効' do
      it '入力情報が無い場合は、フラッシュメッセージdangerが表示される' do
        visit login_path
        expect(page).to have_selector '.login-container'
        submit_with_invalid_information
        expect(page).to have_current_path login_path, ignore_query: true
        expect(page).to have_selector '.login-container'
        expect(page).to have_selector '.alert-danger'
      end

      it '別のリンクへ移動すれば、フラッシュメッセージdangerは消える' do
        visit login_path
        submit_with_invalid_information
        expect(page).to have_current_path login_path, ignore_query: true
        expect(page).to have_selector '.alert-danger'
        visit root_path
        expect(page).not_to have_selector '.alert-danger'
      end
    end

    describe '有効' do
      it '有効な情報の場合は、ユーザーのプロフィールページに移動する' do
        visit login_path
        submit_with_valid_information
        expect(page).to have_current_path user_path(user), ignore_query: true
      end

      it 'ログイン後はログインボタンが消えて、ログアウトボタンが表示される' do
        visit login_path
        submit_with_valid_information
        expect(page).to have_current_path user_path(user), ignore_query: true
        expect(page).not_to have_selector '.btn-login-extend'
        expect(page).to have_selector '.btn-logout-extend'
      end
    end

    it 'ログイン前に開こうとしたページにログイン後移動する' do
      visit edit_user_path(user)
      expect(page).to have_current_path login_path, ignore_query: true
      log_in_by(user)
      expect(page).to have_current_path edit_user_path(user), ignore_query: true
    end
  end

  it 'パスワードリセットページと相互リンクがある' do
    visit login_path
    expect(page).to have_current_path login_path, ignore_query: true
    find_link('こちら', href: new_password_reset_path).click
    expect(page).to have_current_path new_password_reset_path, ignore_query: true
    find_link('こちら', href: login_path).click
    expect(page).to have_current_path login_path, ignore_query: true
  end
end
