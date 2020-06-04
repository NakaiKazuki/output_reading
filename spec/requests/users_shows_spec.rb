require 'rails_helper'

RSpec.describe "UsersShows", type: :request do

  let(:user) { create(:user) }
  let!(:books) { create_list(:books,15,user: user) }
  
  describe "GET /users/:id" do
    context "ユーザーがログインしていない場合" do
      it "/users/:idの取得は無効" do
        get user_path(user)
        follow_redirect!
        expect(flash[:warning]).to be_truthy
        expect(request.fullpath).to eq "/login"
      end
    end

    context "ユーザーがログインしている場合" do
      it "/users/:idの取得は有効" do
        log_in_as(user)
        get user_path(user)
        expect(request.fullpath).to eq "/users/1"
      end
    end

  end
end
