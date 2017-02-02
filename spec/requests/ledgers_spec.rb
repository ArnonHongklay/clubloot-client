require 'rails_helper'

RSpec.describe "Ledgers", type: :request do
  describe "GET /ledgers" do
    it "works! (now write some real specs)" do
      get ledgers_path
      expect(response).to have_http_status(200)
    end
  end
end
