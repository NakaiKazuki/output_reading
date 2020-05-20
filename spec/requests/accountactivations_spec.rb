require 'rails_helper'

RSpec.describe "Accountactivations", type: :request do
  describe "GET /accountactivations" do
    it "works! (now write some real specs)" do
      get accountactivations_index_path
      expect(response).to have_http_status(200)
    end
  end
end
