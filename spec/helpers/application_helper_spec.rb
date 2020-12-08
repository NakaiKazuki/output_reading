require "rails_helper"


RSpec.describe ApplicationHelper, type: :helper do

  describe "#full_title" do
    context "ページタイトルが空の場合" do
      it "ページタイトルは表示されない" do
        expect(helper.full_title).to eq("Output Reading")
      end
    end

    context "ページタイトルがある場合" do
      it "ページタイトルとサイトタイトルが表示" do
        expect(helper.full_title("hoge")).to eq("hoge | Output Reading")
      end
    end
  end
end
