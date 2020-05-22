require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:user){ create(:user) }
  let(:post){ user.posts.build(content: "Lorem ipsum",user:user) }

  describe "Post" do
    it "should be valid" do
      expect(post).to be_valid
    end

    it "should be most recent first" do
      create(:posts, :post_1, user: user, created_at: 10.minutes.ago)
      create(:posts, :post_2, user: user, created_at: 3.years.ago)
      create(:posts, :post_3, user: user, created_at: 2.hours.ago)
      post_4 = create(:posts, :post_4,user: user, created_at: Time.zone.now)
      expect(Post.first).to eq post_4
    end
  end

  describe "user_id" do
    it "should be present" do
      post.user_id = nil
      expect(post).to be_invalid
    end
  end

  describe "content" do
    it "should be present" do
      post.content = "   "
      expect(post).to be_invalid
    end

    it "should not be at most 1600 characters" do
      post.content = "a" * 800
      expect(post).to be_valid
      post.content = "a" * 801
      expect(post).to be_invalid
    end
  end

end
