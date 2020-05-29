require "rails_helper"

RSpec.describe "UsersShows", type: :system do

  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }
  let!(:books) { create_list(:books,15,user: user) }

  describe "users/:id layout" do
    context "ログインしているユーザーと一致する場合" do
      it "編集画面へのリンクが存在する" do
        log_in_by(user)
        visit user_path(user)
        expect(current_path).to eq user_path(user)
        expect(page).to have_link "登録内容を編集する", href:edit_user_path(user), count:1
      end
    end

    context "ログインしているユーザーが一致しない場合" do
      it "編集画面へのリンクは存在しない" do
        log_in_by(other_user)
        visit user_path(user)
        expect(current_path).to eq user_path(user)
        expect(page).not_to have_link "登録内容を編集する", href:edit_user_path(user)
      end
    end
  end

end
