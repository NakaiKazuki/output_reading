require 'rails_helper'

RSpec.describe 'Guests', type: :request do
  let(:admin) { create(:user) }
  let(:guest) { create(:guest_user) }

  def patch_valid_information
    patch user_path(guest), params: {
      user: {
        name: 'Foo Bar',
        email: 'foo@bar.com',
        password: 'foobar',
        password_confirmation: 'foobar'
      }
    }
  end

  describe 'POST /guest_login' do
    it 'ゲストとしてログイン' do
      post guest_login_path
      expect(flash[:success]).to be_truthy
      follow_redirect!
      expect(request.fullpath).to eq '/users/1'
    end
  end

  describe 'POST /users/:id/edit' do
    it '編集不可' do
      log_in_as(guest)
      patch_valid_information
      follow_redirect!
      expect(request.fullpath).to eq user_path(guest)
      expect(flash[:danger]).to be_truthy
    end
  end
end
