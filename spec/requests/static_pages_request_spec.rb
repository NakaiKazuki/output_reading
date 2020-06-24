require 'rails_helper'

RSpec.describe "StaticPages", type: :request do

  describe "GET #home" do
    it "ステータスコードはsuccessと返ってくる" do
      get root_path
      expect(response).to have_http_status(:success)
    end
  end
end
