require 'rails_helper'

RSpec.describe "SiteLayouts", type: :system do
  describe "home layout"do
    it "contains root link"do
      visit root_path
      expect(page).to have_link nil, href: root_path, count:1
    end

    it "contains login link" do
      visit root_path
      expect(page).to have_link "ログイン"#,href: login_path 未実装
    end
  end
end
