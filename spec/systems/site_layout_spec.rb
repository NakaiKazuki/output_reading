require "rails_helper"

RSpec.describe "SiteLayouts", type: :system do
  describe "home layout"do
    it "contains root link"do
      visit root_path
      expect(page).to have_link "Output Reading", href: root_path , count:1
    end

    it "contains login link" do
      visit root_path
      expect(page).to have_link "ログイン", href: login_path , count:1
    end

    it "contains signup link" do
      visit root_path
      expect(page).to have_link  href: signup_path , count:2
    end
  end
end
