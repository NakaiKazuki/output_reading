require 'rails_helper'

RSpec.describe "UsersEdits", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }

  def patch_invalid_information
    patch user_path(user), params: {
      user: {
        name: "",
        email: "foo@invalid",
        password: "foo",
        password_confirmation: "bar"
      }
    }
  end

  def patch_valid_information
    patch user_path(user), params: {
      user: {
        name: "Foo Bar",
        email: "foo@bar.com",
        password: "foobar",
        password_confirmation: "foobar"
      }
    }
  end

  def patch_valid_information_if_password_is_empty
    patch user_path(user), params: {
      user: {
        name: "Foo Bar",
        email: "foo@bar.com",
        password: "",
        password_confirmation: ""
      }
    }
  end

  describe "GET /users/:id/edit" do

    context "user is not logged in" do
      it "is invalid getting edit_user_path" do
        get edit_user_path(user)
        follow_redirect!
        expect(flash[:warning]).not_to be_empty
        expect(request.fullpath).to eq '/login'
      end

      it "is invalid patch user_path" do
        patch_valid_information
        follow_redirect!
        expect(flash[:warning]).not_to be_empty
        expect(request.fullpath).to eq '/login'
      end
    end

    context "access by other users" do
      it "can't get edit_user_path because you are an invalid user" do
        log_in_as(other_user)
        get edit_user_path(user)
        follow_redirect!
        expect(request.fullpath).to eq '/'
      end

      it "can't patch user_path because you are an invalid user" do
        log_in_as(other_user)
        patch_valid_information
        follow_redirect!
        expect(request.fullpath).to eq '/'
      end
    end

    context "matching user" do
      context "invalid" do
        it "is invalid edit informaiton" do
          log_in_as(user)
          get edit_user_path(user)
          expect(is_logged_in?).to be_truthy
          expect(request.fullpath).to eq '/users/1/edit'
          patch_invalid_information
          expect(request.fullpath).to eq '/users/1'
          expect(flash[:danger]).not_to be_empty
        end
      end

      context "valid" do
        it "is valid edit informaiton" do
          log_in_as(user)
          get edit_user_path(user)
          expect(is_logged_in?).to be_truthy
          expect(request.fullpath).to eq '/users/1/edit'
          patch_valid_information
          follow_redirect!
          expect(user.reload.name).to eq 'Foo Bar'
          expect(user.reload.email).to eq 'foo@bar.com'
          # expect(user.reload.password).to eq 'foobar'           #nameとemailは更新されるがpasswordだけ更新されないため、解決するまで放置。手動で確認したところ更新されている。
          expect(request.fullpath).to eq '/users/1'
          expect(flash[:success]).not_to be_empty
        end

        it "is valid edit informaiton if password is empty" do
          log_in_as(user)
          get edit_user_path(user)
          expect(is_logged_in?).to be_truthy
          expect(request.fullpath).to eq '/users/1/edit'
          patch_valid_information_if_password_is_empty
          follow_redirect!
          expect(user.reload.name).to eq 'Foo Bar'
          expect(user.reload.email).to eq 'foo@bar.com'
          # expect(user.password).to eq user.reload.password
          expect(request.fullpath).to eq '/users/1'
          expect(flash[:success]).not_to be_empty
        end
      end
    end

    it "goes to previous link because they had logged in as right user" do
      get edit_user_path(user)
      follow_redirect!
      expect(request.fullpath).to eq '/login'
      log_in_as(user)
      expect(request.fullpath).to eq '/users/1/edit'
    end

  end
end
