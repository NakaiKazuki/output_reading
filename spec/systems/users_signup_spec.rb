require 'rails_helper'

RSpec.describe "UsersSignups", type: :system do
  it "is invalid because it has no name" do
    visit signup_path
    fill_in "名前", with: " "
    fill_in "メールアドレス（例:email@example.com）", with: "user@invalid"
    fill_in "パスワード（6文字以上）", with: "foo"
    fill_in "パスワード（再入力）", with: "bar"
    click_on "この内容で登録する"
    expect(current_path).to eq signup_path
    expect(page).to have_selector "#error_explanation"
    # expect(page).to have_selector 'li', text: '名前を入力してください'
  end
  it "is valid because it fulfils condition of input" do
    visit signup_path
    fill_in "名前", with: "Examle User"
    fill_in "メールアドレス（例:email@example.com）", with: "user@example.com"
    fill_in "パスワード（6文字以上）", with: "password"
    fill_in "パスワード（再入力）", with: "password"
    click_on "この内容で登録する"
    expect(current_path).to eq user_path(1)
    expect(page).not_to  have_selector "#error_explanation"
  end
end
