require 'rails_helper'
RSpec.describe "UsersIndices", type: :request do

  let(:user) { create(:user_add_image) }

  describe "GET /users/index" do

    context "user is not logged in" do
      it "is invalid getting users_path" do
        get users_path
        follow_redirect!
        expect(flash[:warning]).to be_truthy
        expect(request.fullpath).to eq "/login"
      end
    end

    context "user is logged in" do
      it "is valid gettin users_path" do
        log_in_as(user)
        get users_path
        expect(request.fullpath).to eq "/users"
      end
    end
  end
end
