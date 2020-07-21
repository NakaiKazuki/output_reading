require "rails_helper"


RSpec.describe ApplicationHelper, type: :helper do

  describe "#full_title" do
    context "ページタイトルが空の場合" do
      it "removes symbol" do
        expect(helper.full_title).to eq("Output Reading")
      end
    end

    context "ページタイトルがある場合" do
      it "returns title and application name where contains symbol" do
        expect(helper.full_title("hoge")).to eq("hoge | Output Reading")
      end
    end
  end
end
