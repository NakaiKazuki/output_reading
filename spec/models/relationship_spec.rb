require 'rails_helper'

RSpec.describe Relationship, type: :model do
  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }
  let(:relationship) { create(:relationship, follower: other_user, followed: user) }

  describe 'Relationship' do
    it '有効' do
      expect(relationship).to be_valid
    end

    describe '無効' do
      it 'follower_idが空の場合は無効' do
        relationship.follower_id = nil
        expect(relationship).to be_invalid
      end

      it 'followed_idが空の場合は無効' do
        relationship.followed_id = nil
        expect(relationship).to be_invalid
      end

      it 'follower_idとfollower_idの組み合わせは一意' do
        user.active_relationships.create(follower_id: user, followed_id: other_user.id)
        relationship2 = user.active_relationships.build(follower_id: user.id, followed_id: other_user.id)
        expect(relationship2).to be_invalid
      end
    end
  end
end
