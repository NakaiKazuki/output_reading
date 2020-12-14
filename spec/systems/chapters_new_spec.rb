require 'rails_helper'

RSpec.describe 'ChaptersNews', type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }
  let(:book) { create(:book, user: user) }

  def submit_with_invalid_information
    select 1, from: 'chapter_number'
    fill_in 'ここに文章を入力してください（4000文字以内）', with: ' '
    find('.form-submit').click
  end

  def submit_with_valid_information
    select 1, from: 'chapter_number'
    fill_in 'ここに文章を入力してください（4000文字以内）', with: 'テスト投稿'
    find('.form-submit').click
  end

  def submit_with_valid_information_if_add_image
    select 1, from: 'chapter_number'
    fill_in 'ここに文章を入力してください（4000文字以内）', with: 'テスト投稿'
    attach_file('chapter_image', 'spec/fixtures/rails.png')
    find('.form-submit').click
  end

  describe '/books/:book_id/chapters/new layout' do
    describe '無効' do
      it 'ユーザーがログインしていない場合はアクセス不可' do
        visit new_book_chapter_path(book)
        expect(page).to have_current_path login_path, ignore_query: true
        expect(page).to have_selector '.alert-warning'
      end

      it '異なるユーザーのアクセスは無効' do
        log_in_by(other_user)
        visit new_book_chapter_path(book)
        expect(page).to have_current_path root_path, ignore_query: true
      end

      it '無効なフォーム' do
        log_in_by(user)
        visit new_book_chapter_path(book)
        expect(page).to have_current_path new_book_chapter_path(book), ignore_query: true
        submit_with_invalid_information
        expect(page).to have_current_path '/books/1/chapters'
        expect(page).to have_selector '.alert-danger'
        expect(page).to have_selector '#error_explanation'
      end
    end

    describe '有効' do
      it '有効なフォーム' do
        log_in_by(user)
        visit new_book_chapter_path(book)
        submit_with_valid_information
        expect(page).to have_current_path book_path(book), ignore_query: true
        expect(page).to have_selector '.alert-success'
      end

      it '画像を追加した場合でも有効' do
        log_in_by(user)
        visit new_book_chapter_path(book)
        submit_with_valid_information_if_add_image
        expect(page).to have_current_path book_path(book), ignore_query: true
        expect(page).to have_selector '.alert-success'
      end
    end
  end
end
