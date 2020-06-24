require "rails_helper"

RSpec.describe User, type: :model do

  let(:user) { create(:user)}

  describe "User" do
    it "有効" do
      expect(user).to be_valid
    end
  end

  describe "name" do
    it "空白は無効" do
      user.name = " "
      expect(user).to be_invalid
    end


    context "50文字の場合" do
      it "有効" do
        user.name = "a" * 50
        expect(user).to be_valid
      end
    end

    context "51文字の場合" do
      it "長いから無効" do
        user.name = "a" * 51
        expect(user).to be_invalid
      end
    end
  end

  describe "email" do
    it "空白は無効" do
      user.email = "  "
      expect(user).to be_invalid
    end

    context "255 文字の場合" do
      it "有効" do
        user.email = "a" * 243 + "@example.com"
        expect(user).to be_valid
      end
    end

    context "256文字の場合" do
      it "長いから無効" do
        user.email = "a" * 244 + "@example.com"
        expect(user).to be_invalid
      end
    end

    context "有効なアドレスの場合" do
      valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                           first.last@foo.jp alice+bob@baz.cn]
      valid_addresses.each do |valid_address|
        it "有効なアドレスは登録できる" do
          user.email = valid_address
          expect(user).to be_valid
        end
      end
    end

    context "無効なアドレスの場合" do
      invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                             foo@bar_baz.com foo@bar+baz.com foo@example..com]
      invalid_addresses.each do |invalid_address|
        it "無効なアドレスは登録できない" do
          user.email = invalid_address
          expect(user).to be_invalid
        end
      end
    end

    it "一意であるべき" do
      duplicate_user = user.dup
      duplicate_user.email = user.email.upcase
      user.save!
      expect(duplicate_user).to be_invalid
    end

    it "登録時は小文字になる" do
      user.email = "Foo@ExAMPle.CoM"
      user.save!
      expect(user.reload.email).to eq "foo@example.com"
    end
  end

  describe "password と password_confirmation" do
    it "空白は無効" do
      user.password = user.password_confirmation = " " * 6
      expect(user).to be_invalid
    end

    context "5文字の場合" do
      it "短いから無効" do
        user.password = user.password_confirmation = "a" * 5
        expect(user).to be_invalid
      end
    end

    context "6文字の場合" do
      it "有効" do
        user.password = user.password_confirmation = "a" * 6
        expect(user).to be_valid
      end
    end
  end

  describe "User model methods" do
    describe "authenticated?" do
      it "ユーザーのremember_digestがnilの時falseを返す" do
        expect(user.authenticated?(:remember,"")).to be_falsey
      end
    end
  end

  describe "アソシエーション"do

    let!(:book) { create(:book, user: user) }

    it "ユーザー削除時に紐づいたBookのデータを削除" do
      expect{ user.destroy }.to change{ Book.count }.by(-1)
    end

    it "ユーザー削除時に紐づいたChapterのデータを削除" do
      user.chapters.create!(content: "Chapter content",number:1,user:user,book: book)
      expect{ user.destroy }.to change{ Chapter.count }.by(-1)
    end
  end
end
