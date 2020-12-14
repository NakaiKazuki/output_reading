require 'rails_helper'

RSpec.describe 'UsersFollowings', type: :request do
  let(:user) { create(:user) }

  describe 'GET /users/:id/following' do
    describe 'ユーザーがログインしていない場合' do
      it '/users/:id/followingの取得は有効' do
        get following_user_path(user)
        expect(request.fullpath).to eq '/users/1/following'
      end
    end

    describe 'ユーザーがログインしている場合' do
      it '/users/:id/followingの取得は有効' do
        log_in_as(user)
        get following_user_path(user)
        expect(request.fullpath).to eq '/users/1/following'
      end
    end
  end
end
