require 'rails_helper'

RSpec.describe 'UsersEdits', type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }
  let(:guest) { create(:guest_user) }

  def submit_with_invalid_information
    fill_in '名前', with: ''
    fill_in 'メールアドレス（例：email@example.com）', with: 'user@invalid'
    fill_in 'パスワード（6文字以上）', with: 'foo'
    fill_in 'パスワード（再入力）', with: 'bar'
    find('.form-submit').click
  end

  def submit_with_valid_information
    fill_in '名前', with: 'Foo Bar'
    fill_in 'メールアドレス（例：email@example.com）', with: 'foo@bar.com'
    find('.form-submit').click
  end

  def submit_with_valid_information_even_if_password_is_empty
    fill_in '名前', with: 'Foo Bar'
    fill_in 'メールアドレス（例：email@example.com）', with: 'foo@bar.com'
    fill_in 'パスワード（6文字以上）', with: ''
    fill_in 'パスワード（再入力）', with: ''
    find('.form-submit').click
  end

  def submit_with_valid_information_even_if_add_an_image
    fill_in '名前', with: 'Foo Bar'
    fill_in 'メールアドレス（例：email@example.com）', with: 'foo@bar.com'
    fill_in 'パスワード（6文字以上）', with: ''
    fill_in 'パスワード（再入力）', with: ''
    attach_file('user_image', 'spec/fixtures/rails.png')
    find('.form-submit').click
  end

  describe 'users/:id/edit layout' do
    it 'ログインしていない場合は無効' do
      visit edit_user_path(user)
      expect(page).to have_current_path login_path, ignore_query: true
      expect(page).to have_selector '.alert-warning'
    end

    it 'ゲストユーザー編集は無効' do
      log_in_by(guest)
      visit edit_user_path(guest)
      submit_with_valid_information
      expect(page).to have_current_path user_path(guest), ignore_query: true
      expect(page).to have_selector '.alert-danger'
    end

    describe '異なったユーザーのアクセス' do
      it 'edit_user_pathの取得は無効' do
        log_in_by(other_user)
        expect(page).to have_current_path user_path(other_user), ignore_query: true
        visit edit_user_path(user)
        expect(page).to have_current_path root_path, ignore_query: true
      end
    end

    describe '正しいユーザーのアクセス' do
      describe '無効な編集フォーム' do
        it '無効な情報' do
          log_in_by(user)
          visit edit_user_path(user)
          expect(page).to have_current_path edit_user_path(user), ignore_query: true
          submit_with_invalid_information
          expect(page).to have_current_path user_path(user), ignore_query: true
          expect(page).to have_selector '.users-edit-container'
          expect(page).to have_selector '.alert-danger'
          expect(page).to have_selector '#error_explanation'
        end
      end

      describe '有効な編集フォーム' do
        it '有効な情報' do
          log_in_by(user)
          visit edit_user_path(user)
          expect(page).to have_current_path edit_user_path(user), ignore_query: true
          submit_with_valid_information
          expect(user.reload.name).to eq 'Foo Bar'
          expect(user.reload.email).to eq 'foo@bar.com'
          expect(page).to have_current_path user_path(user), ignore_query: true
          expect(page).to have_selector '.alert-success'
        end

        it 'パスワードが空でも有効な情報' do
          log_in_by(user)
          visit edit_user_path(user)
          expect(page).to have_current_path edit_user_path(user), ignore_query: true
          submit_with_valid_information_even_if_password_is_empty
          expect(user.reload.name).to eq 'Foo Bar'
          expect(user.reload.email).to eq 'foo@bar.com'
          expect(page).to have_current_path user_path(user), ignore_query: true
          expect(page).to have_selector '.alert-success'
        end

        it '画像が追加された場合でも有効な情報' do
          log_in_by(user)
          expect(page).to have_current_path user_path(user), ignore_query: true
          expect(page).to have_selector '.user-image-default'
          visit edit_user_path(user)
          expect(page).to have_current_path edit_user_path(user), ignore_query: true
          submit_with_valid_information_even_if_add_an_image
          expect(user.reload.name).to eq 'Foo Bar'
          expect(user.reload.email).to eq 'foo@bar.com'
          expect(page).to have_current_path user_path(user), ignore_query: true
          expect(page).to have_selector '.user-image'
          expect(page).to have_selector '.alert-success'
        end
      end
    end
  end
end
