require 'rails_helper'

RSpec.describe 'PasswordResets', type: :request do
  before do
    ActionMailer::Base.deliveries.clear
  end

  let(:user) { create(:user) }
  let(:non_activation_user) { create(:non_activation_user) }

  describe 'Post /password_resets' do
    it '無効なメールアドレス' do
      get new_password_reset_path
      expect(request.fullpath).to eq '/password_resets/new'
      post password_resets_path, params: { password_reset: { email: '' } }
      expect(flash[:danger]).to be_truthy
      expect(request.fullpath).to eq '/password_resets'
    end

    it '有効なメールアドレス' do
      get new_password_reset_path
      expect(request.fullpath).to eq '/password_resets/new'
      post password_resets_path, params: { password_reset: { email: user.email } }
      expect(flash[:info]).to be_truthy
      expect(flash[:danger]).to be_falsey
      follow_redirect!
      expect(request.fullpath).to eq '/'
    end
  end

  describe 'GET /password_resets/:id/edit' do
    describe '無効' do
      it '無効なメールアドレス' do
        post password_resets_path, params: { password_reset: { email: user.email } }
        user = controller.instance_variable_get(:@user)
        get edit_password_reset_path(user.reset_token, email: '')
        expect(flash[:danger]).to be_truthy
        follow_redirect!
        expect(request.fullpath).to eq '/password_resets/new'
      end
      # object.instance_variable_get(:インスタンス変数)
      # によってインスタンス変数を取得できる。今回はcontrollerの@userを取得

      it '無効なユーザー' do
        post password_resets_path, params: { password_reset: { email: non_activation_user.email } }
        non_activation_user = controller.instance_variable_get(:@user)
        get edit_password_reset_path(non_activation_user.reset_token, email: non_activation_user.email)
        expect(flash[:danger]).to be_truthy
        follow_redirect!
        expect(request.fullpath).to eq '/password_resets/new'
      end

      it '無効なトークン' do
        post password_resets_path, params: { password_reset: { email: user.email } }
        user = controller.instance_variable_get(:@user)
        get edit_password_reset_path('wrong token', email: user.email)
        expect(flash[:danger]).to be_truthy
        follow_redirect!
        expect(request.fullpath).to eq '/password_resets/new'
      end
    end

    it '有効な情報' do
      post password_resets_path, params: { password_reset: { email: user.email } }
      user = controller.instance_variable_get(:@user)
      get edit_password_reset_path(user.reset_token, email: user.email)
      expect(flash[:danger]).to be_falsey
      expect(request.fullpath).to eq "/password_resets/#{user.reset_token}/edit?email=#{CGI.escape(user.email)}"
    end
  end

  describe 'PATCH /password_resets/:id' do
    describe '無効' do
      it '無効なパスワード' do
        post password_resets_path, params: { password_reset: { email: user.email } }
        user = controller.instance_variable_get(:@user)
        get edit_password_reset_path(user.reset_token, email: user.email)
        patch password_reset_path(user.reset_token), params: {
          email: user.email,
          user: {
            password: 'foobaz',
            password_confirmation: 'barquux'
          }
        }
        expect(request.fullpath).to eq "/password_resets/#{user.reset_token}"
      end

      it 'パスワードが空' do
        post password_resets_path, params: { password_reset: { email: user.email } }
        user = controller.instance_variable_get(:@user)
        get edit_password_reset_path(user.reset_token, email: user.email)
        patch password_reset_path(user.reset_token), params: {
          email: user.email,
          user: {
            password: '',
            password_confirmation: ''
          }
        }
        expect(request.fullpath).to eq "/password_resets/#{user.reset_token}"
      end

      it '有効期限の過ぎたトークン' do
        post password_resets_path, params: { password_reset: { email: user.email } }
        user = controller.instance_variable_get(:@user)
        user.update_attribute(:reset_sent_at, 3.hours.ago)
        get edit_password_reset_path(user.reset_token, email: user.email)
        patch password_reset_path(user.reset_token), params: {
          email: user.email,
          user: {
            password: 'foobaz',
            password_confirmation: 'foobaz'
          }
        }
        expect(flash[:danger]).to be_truthy
        follow_redirect!
        expect(request.fullpath).to eq '/password_resets/new'
      end
    end

    it '有効な情報' do
      post password_resets_path, params: { password_reset: { email: user.email } }
      user = controller.instance_variable_get(:@user)
      get edit_password_reset_path(user.reset_token, email: user.email)
      patch password_reset_path(user.reset_token), params: {
        email: user.email,
        user: {
          password: 'foobaz',
          password_confirmation: 'foobaz'
        }
      }
      expect(flash[:success]).to be_truthy
      expect(is_logged_in?).to be_truthy
      follow_redirect!
      expect(request.fullpath).to eq '/users/1'
    end
  end
end
# user = controller.instance_variable_get(:@user) とする理由
# edit_password_reset_pathの引数に当たるreset_tokenは、
# attr_accessorによって生成された仮属性である。
# そのためletで生成したuserにはreset_tokenが存在しないためエラーとなる。
# エラーを回避するために、reset_tokenが代入されたPasswordResetsコントローラの
# @userを使用する必要がある。
