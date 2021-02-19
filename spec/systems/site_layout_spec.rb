require 'rails_helper'

RSpec.describe 'SiteLayouts', type: :system do
  let(:user) { create(:user) }

  describe 'home layout' do
    describe 'ユーザーがログインしていない場合' do
      it '/ へのリンクがある' do
        visit root_path
        expect(page).to have_link 'Output Reading', href: root_path, count: 1
      end

      it '/login へのリンクがある' do
        visit root_path
        expect(page).to have_link 'ログイン', href: login_path, count: 1
      end

      it '/signup へのリンクがる' do
        visit root_path
        expect(page).to have_link href: signup_path, count: 2
      end

      it '/books へのリンクがある' do
        visit root_path
        expect(page).to have_link '投稿一覧', href: books_path, count: 1
      end

      it 'guest_login へのリンクがある' do
        visit root_path
        expect(page).to have_link 'ゲストログイン', href: guest_login_path, count: 1
        click_link 'ゲストログイン', href: guest_login_path
        expect(page).to have_current_path '/users/1'
        expect(page).to have_selector '.alert-success'
      end
    end

    describe 'ユーザーがログインしている場合' do
      before do
        log_in_by(user)
      end

      it '/ へのリンクがある' do
        visit root_path
        expect(page).to have_link 'Output Reading', href: root_path, count: 1
      end

      it '/books へのリンクがある' do
        visit root_path
        expect(page).to have_link '投稿一覧', href: books_path, count: 1
      end

      it '/users へのリンクがある' do
        visit root_path
        expect(page).to have_link 'ユーザー一覧', href: users_path, count: 1
      end

      it '/user/:idへのリンクがある' do
        visit root_path
        expect(page).to have_link 'プロフィール', href: user_path(user), count: 1
      end

      it 'ログアウトボタンがある' do
        visit root_path
        expect(page).to have_link 'ログアウト', href: logout_path, count: 1
      end
    end
  end
end
