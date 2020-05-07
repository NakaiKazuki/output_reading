require 'rails_helper'
RSpec.describe "UsersIndices", type: :request do

  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }

  describe "GET /users/index" do

    context "user is not logged in" do
      it "is invalid getting edit_users_path" do
        get users_path
        follow_redirect!
        expect(flash[:warning]).to be_truthy
        expect(request.fullpath).to eq '/login'
      end
    end

  end
end
