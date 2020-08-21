require 'rails_helper'

RSpec.describe "UsersLogins", type: :request do

  let(:user) { create(:user) }
  let(:non_activation_user) { create(:non_activation_user) }

   # ログインのメソッド
   def post_invalid_information
      post login_path, params: {
        session: {
          email: "",
          password: ""
        }
      }
    end

    def post_valid_information(login_user, remember_me = 0)
      post login_path, params: {
        session: {
          email: login_user.email,
          password: login_user.password,
          remember_me: remember_me
        }
      }
    end

  describe "GET /login" do
    describe "無効なフォーム情報" do
      it "失敗したときは、フラッシュメッセージdangerが表示される" do
        get login_path
        post_invalid_information
        expect(flash[:danger]).to be_truthy
        expect(is_logged_in?).to be_falsey
        expect(request.fullpath).to eq '/login'
      end

      it "アカウントが有効化されていない場合は、フラッシュメッセージdangerが表示される" do
        get login_path
        post_valid_information(non_activation_user)
        expect(flash[:danger]).to be_truthy
        expect(is_logged_in?).to be_falsey
        follow_redirect!
        expect(request.fullpath).to eq "/"
      end
    end

    describe "有効なフォーム情報" do
      it "成功時フラッシュメッセージdangerは表示されない" do
        get login_path
        post_valid_information(user)
        expect(flash[:danger]).to be_falsey
        expect(is_logged_in?).to be_truthy
        follow_redirect!
        expect(request.fullpath).to eq '/users/1'
      end

      it "ログインとログアウト" do
        get login_path
        post_valid_information(user)
        expect(is_logged_in?).to be_truthy
        follow_redirect!
        expect(request.fullpath).to eq '/users/1'
        delete logout_path
        expect(is_logged_in?).to be_falsey
        follow_redirect!
        expect(request.fullpath).to eq '/'
      end
    end

    it "権限のあるユーザーとしてログインしたら、表示しようとしていた画面に移動" do
      get edit_user_path(user)
      follow_redirect!
      expect(request.fullpath).to eq '/login'
      log_in_as(user)
      expect(request.fullpath).to eq '/users/1/edit'
    end

  end

  describe "remember_me" do
    it "別のウインドウで2度目のログアウトは無効" do
      get login_path
      post_valid_information(user,0)
      expect(is_logged_in?).to be_truthy
      follow_redirect!
      expect(request.fullpath).to eq '/users/1'
      delete logout_path
      expect(is_logged_in?).to be_falsey
      follow_redirect!
      expect(request.fullpath).to eq '/'
      #別のウインドウで、2度目のログアウト
      delete logout_path
      follow_redirect!
      expect(request.fullpath).to eq '/'
    end

    it "remember_meがチェックされた時remember_tokenが作成される" do
      get login_path
      post_valid_information(user,1)
      expect(is_logged_in?).to be_truthy
      expect(cookies[:remember_token]).not_to be_empty
    end

    it "remember_meがチェックされない時remember_tokenは作成されない" do
      get login_path
      post_valid_information(user,0)
      expect(is_logged_in?).to be_truthy
      expect(cookies[:remember_token]).to be_nil
    end

    it "ログアウトしたらremember_tokenは空になる" do
      get login_path
      post_valid_information(user,1)
      expect(is_logged_in?).to be_truthy
      expect(cookies[:remember_token]).not_to be_empty
      delete logout_path
      expect(is_logged_in?).to be_falsey
      expect(cookies[:remember_token]).to be_empty
    end
  end
end
