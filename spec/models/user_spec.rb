require "rails_helper"

RSpec.describe User, type: :model do

  let(:user) { create(:user)}
  let(:other_user) { create(:other_user) }

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


    describe "50文字の場合" do
      it "有効" do
        user.name = "a" * 50
        expect(user).to be_valid
      end
    end

    describe "51文字の場合" do
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

    describe "255 文字の場合" do
      it "有効" do
        user.email = "a" * 243 + "@example.com"
        expect(user).to be_valid
      end
    end

    describe "256文字の場合" do
      it "長いから無効" do
        user.email = "a" * 244 + "@example.com"
        expect(user).to be_invalid
      end
    end

    describe "有効なアドレスの場合" do
      valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                           first.last@foo.jp alice+bob@baz.cn]
      valid_addresses.each do |valid_address|
        it "有効なアドレスは登録できる" do
          user.email = valid_address
          expect(user).to be_valid
        end
      end
    end

    describe "無効なアドレスの場合" do
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

  describe "password" do
    it "空白は無効" do
      user.password = user.password_confirmation = " " * 6
      expect(user).to be_invalid
    end

    describe "5文字の場合" do
      it "短いから無効" do
        user.password = user.password_confirmation = "a" * 5
        expect(user).to be_invalid
      end
    end

    describe "6文字の場合" do
      it "有効" do
        user.password = user.password_confirmation = "a" * 6
        expect(user).to be_valid
      end
    end
  end

  describe "モデルメソッド" do
    describe "authenticated?" do
      it "ユーザーのremember_digestがnilの時falseを返す" do
        expect(user.authenticated?(:remember,"")).to be_falsey
      end
    end
  end

  describe "お気に入り登録" do
    describe "like?" do
      let(:book) { create(:book,user: user) }

      it "ユーザーがお気に入り登録していなければfalseを登録していればtrueを返す" do
        expect(user.favorite_books.include?(book)).to be_falsey
        create(:favorite,user: user,book: book)
        expect(user.favorite_books.include?(book)).to be_truthy
      end
    end
  end

  describe "ユーザーフォロー" do
    describe "followers" do
      it "ユーザーにフォローされていなければfalse、フォローされていればtrueを返す" do
        expect(other_user.followers.include?(user)).to be_falsey
        user.active_relationships.create(follower_id: user, followed_id: other_user.id)
        expect(other_user.followers.include?(user)).to be_truthy
      end
    end

    describe "following?" do
        it "ユーザーがフォローしていなければfalse、フォローしていればtrueを返す" do
          expect(user.following.include?(other_user)).to be_falsey
          user.active_relationships.create(follower_id: user, followed_id: other_user.id)
          expect(user.following.include?(other_user)).to be_truthy
        end
    end
  end

  describe "アソシエーション"do

    let!(:book) { create(:book, user: user) }

    it "ユーザー削除時に紐づいたBookのデータを削除" do
      expect{ user.destroy }.to change{ Book.count }.by(-1)
    end

    it "ユーザー削除時に紐づいたChapterのデータを削除" do
      user.chapters.create(content: "Chapter content",number:1,user:user,book: book)
      expect{ user.destroy }.to change{ Chapter.count }.by(-1)
    end

    it "ユーザー削除時に紐づいたFavoriteのデータ削除" do
      user.favorites.create(user:user,book:book)
      expect{ user.destroy }.to change{ Favorite.count }.by(-1)
    end

    it "ユーザー削除時に紐づいたRelationshipのデータ削除" do
      user.active_relationships.create(follower_id: user, followed_id: other_user.id)
      expect{ user.destroy }.to change{ Relationship.count }.by(-1)
    end
  end
end
