require 'rails_helper'

RSpec.describe "UsersDestroys", type: :request do

  let!(:admin) { create(:user) }
  let(:non_admin_user) { create(:other_user) }

  describe "DELETE /users/:id " do
    describe "無効" do
      it "ログインしていない時に削除を実行すると、ログイン画面に移動" do
        delete user_path(admin)
        follow_redirect!
        expect(flash[:warning]).to be_truthy
        expect(request.fullpath).to eq "/login"
      end

      it "管理者以外の削除は無効になりホーム画面に移動" do
        log_in_as(non_admin_user)
        expect{delete user_path(admin)}.to change {User.count}.by(0)
        follow_redirect!
        expect(request.fullpath).to eq "/"
      end
    end

    describe "有効" do
      
      let!(:non_admin_user) { create(:other_user) }

      it "管理者がログインして削除を実行する場合は有効" do
        log_in_as(admin)
        expect{delete user_path(non_admin_user)}.to change {User.count}.by(-1)
        follow_redirect!
        expect(flash[:success]).to be_truthy
        expect(request.fullpath).to eq "/users"
      end
    end
  end
end
