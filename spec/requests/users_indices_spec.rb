require 'rails_helper'
RSpec.describe "UsersIndices", type: :request do

  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }

  describe "GET /users" do

    context "ユーザーがログインしていない場合" do
      it "users_pathの取得は無効" do
        get users_path
        follow_redirect!
        expect(flash[:warning]).to be_truthy
        expect(request.fullpath).to eq "/login"
      end
    end

    context "ユーザーがログインしている場合" do
      it "users_path の取得に成功" do
        log_in_as(user)
        get users_path
        expect(request.fullpath).to eq "/users"
      end
    end
  end
end
