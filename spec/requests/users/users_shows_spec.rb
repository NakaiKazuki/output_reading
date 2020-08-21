require 'rails_helper'

RSpec.describe "UsersShows", type: :request do

  let(:user) { create(:user) }

  describe "GET /users/:id" do
    describe "ユーザーがログインしていない場合" do
      it "/users/:idの取得は有効" do
        get user_path(user)
        expect(request.fullpath).to eq "/users/1"
      end
    end

    describe "ユーザーがログインしている場合" do
      it "/users/:idの取得は有効" do
        log_in_as(user)
        get user_path(user)
        expect(request.fullpath).to eq "/users/1"
      end
    end
  end
end
