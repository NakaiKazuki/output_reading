require 'rails_helper'

RSpec.describe 'BooksShows', type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }
  let(:book) { create(:book, :add_image, user: user) }
  let(:other_book) { create(:book2, user: user) }
  let!(:chapter) { create(:chapter, user: user, book: book) }
  let!(:other_book_chapter) { create(:other_book_chapter, user: user, book: other_book) }

  describe '/book/:id layout' do
    describe 'ログインしていない場合' do
      it 'ログインしていなくてもアクセス可能' do
        visit book_path(book)
        expect(page).to have_current_path book_path(book), ignore_query: true
      end

      it '表示される投稿数は1ページ10個まで' do
        create_list(:chapters, 11, user: user, book: book)
        visit book_path(book)
        expect(page).to have_selector '.pagination'
        expect(page).to have_selector '.chapter-content', count: 10
      end

      it '投稿に画像があれば表示される' do
        visit book_path(book)
        expect(page).to have_selector '.book-image'
      end

      it '投稿者の名前がある' do
        visit book_path(book)
        expect(page).to have_link book.user.name, href: user_path(user)
      end

      it '別のBookデータに紐づいたChapterデータは投稿者が同じでも表示されない' do
        visit book_path(book)
        expect(chapter.user_id).to eq other_book_chapter.user_id
        expect(page).to have_selector '.chapter-content', text: chapter.content
        expect(page).not_to have_selector '.chapter-content', text: other_book_chapter.content
      end

      it '非ログイン時章の投稿の編集と削除のリンクは表示されない' do
        visit book_path(book)
        expect(page).not_to have_link '編集', href: edit_book_chapter_path(book_id: chapter.book_id, number: chapter.number)
        expect(page).not_to have_link '削除', href: book_chapter_path(book_id: chapter.book_id, number: chapter.number)
      end

      it 'フォローボタンは存在しない' do
        visit book_path(book)
        expect(page).to have_current_path book_path(book), ignore_query: true
        expect(page).not_to have_button 'お気に入り登録'
      end

      it '楽天ブックスで検索へのリンクは別タブで開かれる', js: true do
        visit book_path(book)
        expect(page).to have_current_path book_path(book), ignore_query: true
        find_link('楽天で検索する', href: search_books_path).click
        switch_to_window(windows.last)
        expect(page).to have_current_path search_books_path, ignore_query: true
      end
    end

    describe '一致しないユーザーとしてログイン' do
      it '他のユーザーの投稿には編集と削除のリンクは表示されない' do
        log_in_by(other_user)
        visit book_path(book)
        expect(page).not_to have_link '編集', href: edit_book_chapter_path(book_id: chapter.book_id, number: chapter.number)
        expect(page).not_to have_link '削除', href: book_chapter_path(book_id: chapter.book_id, number: chapter.number)
      end

      it 'お気に入り登録と削除ボタンが機能している', js: true do
        log_in_by(other_user)
        visit book_path(book)
        expect {
          click_button('お気に入り登録')
          wait_for_ajax
        }.to change(Favorite, :count).by(1)
        expect(page).to have_current_path book_path(book), ignore_query: true
        expect {
          click_button('お気に入り登録解除')
          wait_for_ajax
        }.to change(Favorite, :count).by(-1)
        expect(page).to have_current_path book_path(book), ignore_query: true
      end
    end

    describe '投稿者としてログイン' do
      it '投稿に編集と削除のリンクが表示される' do
        log_in_by(user)
        visit book_path(book)
        expect(page).to have_link '編集', href: edit_book_chapter_path(book_id: chapter.book_id, number: chapter.number)
        expect(page).to have_link '削除', href: book_chapter_path(book_id: chapter.book_id, number: chapter.number)
      end

      it '編集リンク', js: true do
        log_in_by(user)
        visit book_path(book)
        find_link('編集', href: edit_book_chapter_path(book_id: chapter.book_id, number: chapter.number)).click
        expect(page).to have_current_path edit_book_chapter_path(book_id: chapter.book_id, number: chapter.number), ignore_query: true
      end

      it '削除リンク', js: true do
        log_in_by(user)
        visit book_path(book)
        expect {
          find_link('削除', href: book_chapter_path(book_id: chapter.book_id, number: chapter.number)).click
          page.accept_confirm '選択した投稿を削除しますか？'
          expect(page).to have_selector '.alert-success'
        }.to change(Chapter, :count).by(-1)
        expect(page).to have_current_path book_path(book), ignore_query: true
      end

      it '新規投稿作成リンク' do
        log_in_by(user)
        visit book_path(book)
        find_link('本の内容を書き出す', href: new_book_chapter_path(book_id: book)).click
        expect(page).to have_current_path new_book_chapter_path(book_id: book), ignore_query: true
      end

      it 'お気に入り登録と削除ボタンが機能している', js: true do
        log_in_by(user)
        visit book_path(book)
        expect {
          click_button('お気に入り登録')
          wait_for_ajax
        }.to change(Favorite, :count).by(1)
        expect(page).to have_current_path book_path(book), ignore_query: true
        expect {
          click_button('お気に入り登録解除')
          wait_for_ajax
        }.to change(Favorite, :count).by(-1)
        expect(page).to have_current_path book_path(book), ignore_query: true
      end
    end
  end
end
