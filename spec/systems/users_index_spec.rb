require 'rails_helper'

RSpec.describe 'UsersIndices', type: :system do
  let(:admin) { create(:user, :add_image) }
  let!(:non_admin) { create(:other_user) }

  describe '/users layout' do
    it 'ログインしていない状態でアクセス不可能' do
      visit users_path
      expect(page).to have_current_path login_path, ignore_query: true
      expect(page).to have_selector '.alert-warning'
    end

    it 'ユーザー検索機能' do
      log_in_by(admin)
      visit users_path
      expect(page).to have_current_path users_path, ignore_query: true
      expect(page).to have_link non_admin.name, href: user_path(non_admin)
      fill_in 'ユーザー名を入力してください', with: 'foobar'
      find('.search-submit').click
      expect(page).not_to have_link non_admin.name, href: user_path(non_admin)
      fill_in 'ユーザー名を入力してください', with: non_admin.name
      find('.search-submit').click
      expect(page).to have_link non_admin.name, href: user_path(non_admin)
    end

    it 'ページネーションで表示されるユーザーは15名' do
      create_list(:users, 15)
      log_in_by(admin)
      visit users_path
      expect(page).to have_current_path users_path, ignore_query: true
      expect(page).to have_selector '.pagination'
      expect(page).to have_selector '.user-name', count: 15
    end

    it '一覧の名前をクリックで、そのユーザーのプロフィール画面へ移動' do
      log_in_by(admin)
      visit users_path
      expect(page).to have_current_path users_path, ignore_query: true
      find_link(admin.name, href: user_path(admin)).click
      expect(page).to have_current_path user_path(admin), ignore_query: true
    end

    it 'ユーザーが画像を設定していれば、設定されている画像を表示する。なければデフォルト画像を表示' do
      log_in_by(admin)
      visit users_path
      expect(page).to have_current_path users_path, ignore_query: true
      expect(page).to have_selector '.user-image', count: 1
      expect(page).to have_selector '.user-image-default'
    end

    describe '非管理者としてログイン' do
      it '非管理者としてログインした場合は、一覧内にユーザー削除リンクは表示されない' do
        log_in_by(non_admin)
        visit users_path
        expect(page).to have_current_path users_path, ignore_query: true
        expect(page).not_to have_link '削除', href: user_path(non_admin)
      end
    end

    describe '管理者としてログイン' do
      it '管理者としてログインした場合は、非管理者ユーザーの削除リンクが表示される', js: true do
        log_in_by(admin)
        visit users_path
        expect(page).to have_current_path users_path, ignore_query: true
        expect(page).not_to have_link '削除', href: user_path(admin)
        expect(page).to have_link non_admin.name, href: user_path(non_admin)
        expect {
          find_link('削除', href: user_path(non_admin)).click
          page.accept_confirm '選択したユーザーを削除しますか？'
          expect(page).to have_selector '.alert-success'
        }.to change(User, :count).by(-1)
        expect(page).to have_current_path users_path, ignore_query: true
        expect(page).not_to have_link non_admin.name, href: user_path(non_admin)
      end
    end
  end
end
