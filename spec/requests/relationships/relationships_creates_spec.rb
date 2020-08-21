require 'rails_helper'

RSpec.describe "RelationshipsCreates", type: :request do

  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }

  describe "POST /relationships" do
    it "ログインしていない場合は無効" do
      expect{
        post relationships_path(followed_id: other_user.id)
        follow_redirect!
      }.not_to change { Relationship.count }
      expect(flash[:warning]).to be_truthy
      expect(request.fullpath).to eq "/login"
    end

    it "ログインしている場合は有効" do
      log_in_as(user)
      expect{
        post relationships_path(followed_id: other_user.id)
        follow_redirect!
      }.to change {Relationship.count}.by(1)
      expect(request.fullpath).to eq user_path(other_user)
    end
  end
end
