require 'rails_helper'

RSpec.describe "UsersFollowers", type: :request do
  let(:user) { create(:user) }

  describe "GET /users/:id/followers" do
    describe "ユーザーがログインしていない場合" do
      it "/users/:id/followersの取得は有効" do
        get followers_user_path(user)
        expect(request.fullpath).to eq "/users/1/followers"
      end
    end

    describe "ユーザーがログインしている場合" do
      it "/users/:id/followersの取得は有効" do
        log_in_as(user)
        get followers_user_path(user)
        expect(request.fullpath).to eq "/users/1/followers"
      end
    end
  end
end
