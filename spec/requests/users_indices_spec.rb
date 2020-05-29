require 'rails_helper'
RSpec.describe "UsersIndices", type: :request do

  let!(:admin) { create(:user) }
  let!(:other_user) { create(:other_user) }
  let!(:users) { create_list(:users,15) }

  describe "GET /users" do

    context "ユーザーがログインしていない場合は無効" do
      it "ログインしていないusers_pathの取得は無効" do
        get users_path
        follow_redirect!
        expect(flash[:warning]).to be_truthy
        expect(request.fullpath).to eq "/login"
      end
    end

    context "ユーザーがログインしている場合は有効" do
      it "is valid gettin users_path" do
        log_in_as(admin)
        get users_path
        expect(request.fullpath).to eq "/users"
      end
    end
  end

  describe "DELETE /users/:id " do
    context "無効" do
      it "ログインしていない時に削除を実行すると、ログイン画面に移動" do
        delete user_path(other_user)
        follow_redirect!
        expect(flash[:warning]).to be_truthy
        expect(request.fullpath).to eq "/login"
      end

      it "管理者以外の削除は無効になりホーム画面に移動" do
        log_in_as(other_user)
        expect{delete user_path(admin)}.to change {User.count}.by(0)
        follow_redirect!
        expect(request.fullpath).to eq "/"
      end

    end

    context "有効" do
      it "管理者がログインして削除を実行する場合は有効" do
        log_in_as(admin)
        expect{delete user_path(other_user)}.to change {User.count}.by(-1)
        follow_redirect!
        expect(flash[:success]).to be_truthy
        expect(request.fullpath).to eq "/users"
      end
    end
  end
end
