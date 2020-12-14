require 'rails_helper'

RSpec.describe "RelationshipsDestroys", type: :request do

  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }
  let!(:relationship) { create(:relationship,follower: user,followed: other_user) }

  describe " DELETE /relationships/:id" do
    it "ログインしていない場合は無効" do
      expect{
        delete relationship_path(relationship)
        follow_redirect!
      }.not_to change { Relationship.count }
      expect(flash[:warning]).to be_truthy
      expect(request.fullpath).to eq "/login"
    end

    it "ログインしている場合は有効" do
      log_in_as(user)
      expect{
        delete relationship_path(relationship)
        follow_redirect!
      }.to change {Relationship.count}.by(-1)
      expect(request.fullpath).to eq user_path(other_user)
    end
  end
end
