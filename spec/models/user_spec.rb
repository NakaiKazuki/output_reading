require "rails_helper"

RSpec.describe User, type: :model do

  let(:user) { create(:user)}

  describe "User" do
    it "should be valid" do
      expect(user).to be_valid
    end
  end

  describe "name" do
    it "gives presence" do
      user.name = " "
      expect(user).to be_invalid
    end


    context "50 characters" do
      it "is not too long" do
        user.name = "a" * 50
        expect(user).to be_valid
      end
    end

    context "51 characters" do
      it "is too long" do
        user.name = "a" * 51
        expect(user).to be_invalid
      end
    end
  end

  describe "email" do
    it "gives presence" do
      user.email = "  "
      expect(user).to be_invalid
    end

    context "255 characters" do
      it "is not too long" do
        user.email = "a" * 243 + "@example.com"
        expect(user).to be_valid
      end
    end

    context "256 characters" do
      it "is too long" do
        user.email = "a" * 244 + "@example.com"
        expect(user).to be_invalid
      end
    end

    context "valid addresses" do
      valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                           first.last@foo.jp alice+bob@baz.cn]
      valid_addresses.each do |valid_address|
        it "should accept valid addresses" do
          user.email = valid_address
          expect(user).to be_valid
        end
      end
    end

    context "invalid addresses" do
      invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                             foo@bar_baz.com foo@bar+baz.com foo@example..com]
      invalid_addresses.each do |invalid_address|
        it "should reject invalid addresses" do
          user.email = invalid_address
          expect(user).to be_invalid
        end
      end
    end

    it "should be unique" do
      duplicate_user = user.dup
      duplicate_user.email = user.email.upcase
      user.save!
      expect(duplicate_user).to be_invalid
    end

    it "should be saved as lower-case" do
      user.email = "Foo@ExAMPle.CoM"
      user.save!
      expect(user.reload.email).to eq "foo@example.com"
    end
  end

  describe "password and password_confirmation" do
    it "should be present (nonblank)" do
      user.password = user.password_confirmation = " " * 6
      expect(user).to be_invalid
    end

    context "5 characters" do
      it "is too short" do
        user.password = user.password_confirmation = "a" * 5
        expect(user).to be_invalid
      end
    end

    context "6 characters" do
      it "is not too short" do
        user.password = user.password_confirmation = "a" * 6
        expect(user).to be_valid
      end
    end
  end

  describe "User model methods" do
    describe "authenticated?" do
      it "return false for a user with nil digest" do
        expect(user.authenticated?(:remember,"")).to be_falsey
      end
    end
  end

end
