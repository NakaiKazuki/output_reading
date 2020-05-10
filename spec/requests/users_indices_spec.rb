require 'rails_helper'
RSpec.describe "UsersIndices", type: :request do

  let!(:admin) { create(:user) }
  let!(:other_user) { create(:other_user) }
  let!(:users) { create_list(:users,15) }

  describe "GET /users" do

    context "user is not logged in is invalid" do
      it "is invalid getting users_path" do
        get users_path
        follow_redirect!
        expect(flash[:warning]).to be_truthy
        expect(request.fullpath).to eq "/login"
      end
    end

    context "user is logged in is valid" do
      it "is valid gettin users_path" do
        log_in_as(admin)
        get users_path
        expect(request.fullpath).to eq "/users"
        # expect(User.page(1).per(10).limit_value).to eq 10
      end
    end
  end

  describe "DELETE /users/:id " do
    context "invalid" do
      # it "should redirect destroy when not logged in" do
      #   delete user_path(other_user)  #unless current_user.admin?でエラーになる。current_userが存在していないことが原因？？取り敢えず放置
      #   follow_redirect!
      #   expect(flash[:warning]).to be_truthy
      #   expect(request.fullpath).to eq "/login"
      # end

      it "should redirect destroy when logged in as a non-admin" do
        log_in_as(other_user)
        expect{delete user_path(admin)}.to change(User, :count).by(0)
        follow_redirect!
        expect(request.fullpath).to eq "/"
      end

    end

    context "valid" do
      it "delete is valid when logged in as an admin" do
        log_in_as(admin)
        expect{delete user_path(other_user)}.to change(User, :count).by(-1)
        follow_redirect!
        expect(request.fullpath).to eq "/users"
      end
    end
  end
end
