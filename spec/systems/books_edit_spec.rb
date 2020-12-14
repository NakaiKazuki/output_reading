require 'rails_helper'

RSpec.describe 'BooksEdits', type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }
  let(:book) { create(:book, user: user) }
  let(:other_book) { create(:other_book, user: other_user) }

  def submit_with_invalid_information
    fill_in '本のタイトルを入力してください（50文字以内）', with: ' '
    find('.form-submit').click
  end

  def submit_with_valid_information
    fill_in '本のタイトルを入力してください（50文字以内）', with: '投稿編集テスト'
    find('.form-submit').click
  end

  def submit_with_valid_information_if_add_image
    fill_in '本のタイトルを入力してください（50文字以内）', with: '投稿編集テスト'
    attach_file('book_image', 'spec/fixtures/rails.png')
    find('.form-submit').click
  end

  def submit_with_valid_information_if_non_title
    attach_file('book_image', 'spec/fixtures/rails.png')
    find('.form-submit').click
  end

  describe '/books/:id/edit layout' do
    describe '無効' do
      it 'ログインしていない場合は無効' do
        visit edit_book_path(book)
        expect(page).to have_current_path login_path, ignore_query: true
        expect(page).to have_selector '.alert-warning'
      end

      it '他人の投稿編集ページへのアクセスはできない' do
        log_in_by(other_user)
        visit edit_book_path(book)
        expect(page).to have_current_path root_path, ignore_query: true
      end

      it '無効な情報' do
        log_in_by(user)
        visit edit_book_path(book)
        expect(page).to have_current_path edit_book_path(book), ignore_query: true
        submit_with_invalid_information
        expect(page).to have_current_path book_path(book), ignore_query: true
        expect(page).to have_selector '.books-edit-container'
        expect(page).to have_selector '.alert-danger'
        expect(page).to have_selector '#error_explanation'
      end
    end

    describe '有効' do
      before do
        log_in_by(user)
      end

      it '有効な情報' do
        visit edit_book_path(book)
        expect(page).to have_current_path edit_book_path(book), ignore_query: true
        submit_with_valid_information
        expect(book.reload.title).to eq '投稿編集テスト'
        expect(page).to have_current_path book_path(book), ignore_query: true
        expect(page).to have_selector '.alert-success'
      end

      it '画像を追加しても有効' do
        visit edit_book_path(book)
        expect(page).to have_current_path edit_book_path(book), ignore_query: true
        submit_with_valid_information_if_add_image
        expect(book.reload.title).to eq '投稿編集テスト'
        expect(book.reload.image).to be_truthy
        expect(page).to have_current_path book_path(book), ignore_query: true
        expect(page).to have_selector '.alert-success'
      end

      it '画像の追加のみでも' do
        visit edit_book_path(book)
        expect(page).to have_current_path edit_book_path(book), ignore_query: true
        submit_with_valid_information_if_non_title
        expect(book.title).to eq book.reload.title
        expect(book.reload.image).to be_truthy
        expect(page).to have_current_path book_path(book), ignore_query: true
        expect(page).to have_selector '.alert-success'
      end
    end
  end
end
