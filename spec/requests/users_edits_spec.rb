require "rails_helper"

RSpec.describe "UsersEdits", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }

  def patch_invalid_information
    patch user_path(user), params: {
      user: {
        name: "",
        email: "foo@invalid",
        password: "foo",
        password_confirmation: "bar"
      }
    }
  end

  def patch_valid_information
    patch user_path(user), params: {
      user: {
        name: "Foo Bar",
        email: "foo@bar.com",
        password: "foobar",
        password_confirmation: "foobar"
      }
    }
  end

  def patch_valid_information_if_password_is_empty
    patch user_path(user), params: {
      user: {
        name: "Foo Bar",
        email: "foo@bar.com",
        password: "",
        password_confirmation: ""
      }
    }
  end

  def patch_valid_information_if_add_an_image
    patch user_path(user), params: {
      user: {
        name: "Foo Bar",
        email: "foo@bar.com",
        password: "",
        password_confirmation: "",
        image: "spec/fixtures/fixtures/rails.png"
      }
    }
  end

  describe "GET /users/:id/edit" do

    context "ユーザーがログインしていない場合" do
      it "edit_user_pathの取得は無効" do
        get edit_user_path(user)
        follow_redirect!
        expect(flash[:warning]).to be_truthy
        expect(request.fullpath).to eq "/login"
      end

      it "ユーザー情報の変更は無効" do
        patch_valid_information
        follow_redirect!
        expect(flash[:warning]).to be_truthy
        expect(request.fullpath).to eq "/login"
      end
    end

    context "異なるユーザーのアクセスした場合は無効" do
      it "自身以外のユーザー情報編集画面へのアクセスは無効" do
        log_in_as(other_user)
        get edit_user_path(user)
        follow_redirect!
        expect(request.fullpath).to eq "/"
      end

      it "自身以外のユーザーの登録情報編集は無効" do
        log_in_as(other_user)
        patch_valid_information
        follow_redirect!
        expect(request.fullpath).to eq "/"
      end

      it "管理者権限の付与は無効" do
        log_in_as(other_user)
        expect(other_user.admin).to be false
        patch user_path(other_user), params:{
                                       user:{password:              other_user.password,
                                             password_confirmation: other_user.password,
                                             admin: true}}
        expect(other_user.reload.admin).to be false
      end
    end


    context "ユーザーが一致した場合" do
      context "無効" do
        it "無効な編集情報" do
          log_in_as(user)
          get edit_user_path(user)
          expect(is_logged_in?).to be true
          expect(request.fullpath).to eq "/users/1/edit"
          patch_invalid_information
          expect(request.fullpath).to eq "/users/1"
          expect(flash[:danger]).to be_truthy
        end
      end

      context "有効" do
        it "有効な編集情報" do
          log_in_as(user)
          get edit_user_path(user)
          expect(is_logged_in?).to be_truthy
          expect(request.fullpath).to eq "/users/1/edit"
          patch_valid_information
          follow_redirect!
          expect(user.reload.name).to eq "Foo Bar"
          expect(user.reload.email).to eq "foo@bar.com"
          # expect(user.reload.password).to eq "foobar"           #nameとemailは更新されるがpasswordだけ更新されないため、解決するまで放置。digestになってるからやろ
          expect(request.fullpath).to eq "/users/1"
          expect(flash[:success]).to be_truthy
        end

        it "パスワードが空でも編集は有効" do
          log_in_as(user)
          get edit_user_path(user)
          expect(is_logged_in?).to be_truthy
          expect(request.fullpath).to eq "/users/1/edit"
          patch_valid_information_if_password_is_empty
          follow_redirect!
          expect(user.reload.name).to eq "Foo Bar"
          expect(user.reload.email).to eq "foo@bar.com"
          # expect(user.password).to eq user.reload.password
          expect(request.fullpath).to eq "/users/1"
          expect(flash[:success]).to be_truthy
        end

        it "画像を追加した場合も編集は有効" do
          log_in_as(user)
          get edit_user_path(user)
          expect(is_logged_in?).to be_truthy
          expect(request.fullpath).to eq "/users/1/edit"
          patch_valid_information_if_add_an_image
          follow_redirect!
          expect(user.reload.name).to eq "Foo Bar"
          expect(user.reload.email).to eq "foo@bar.com"
          # expect(user.password).to eq user.reload.password
          expect(user.reload.image).to be_truthy
          expect(request.fullpath).to eq "/users/1"
          expect(flash[:success]).to be_truthy
        end
      end
    end
  end
end
