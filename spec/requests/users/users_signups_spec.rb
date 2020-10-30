require 'rails_helper'

RSpec.describe "UsersSignups", type: :request do

  def post_invalid_information
    post signup_path,params:{
      user:{
        name: "",
        email: "user@invalid",
        password: "foo",
        password_confirmation: "bar"
      }
    }
  end

  def post_valid_information
    post signup_path,params:{
      user:{
        name: "Example User",
        email: "user@example.com",
        password: "foobar",
        password_confirmation: "foobar"
      }
    }
  end

  def post_valid_information_with_image
    post signup_path,params:{
      user:{
        name: "Example User",
        email: "user@example.com",
        password: "foobar",
        password_confirmation: "foobar",
        image: "spec/fixtures/fixtures/rails.png"
      }
    }
  end

  describe "GET /signup" do
    it "無効な登録情報" do
      expect{post_invalid_information}.not_to change {User.count}
      expect(flash[:success]).to be nil
    end

    it "有効な登録情報" do
      expect{post_valid_information}.to change {User.count}.by(1)
      expect(is_logged_in?).to be_falsey
      follow_redirect!
      expect(request.fullpath).to eq '/'
      expect(flash[:info]).to be_truthy
    end

    it "画像が追加された場合でも有効な登録情報" do
      expect{post_valid_information_with_image}.to change {User.count}.by(1)
      expect(is_logged_in?).to be_falsey
      follow_redirect!
      expect(request.fullpath).to eq '/'
      expect(flash[:info]).to be_truthy
    end
  end
end
