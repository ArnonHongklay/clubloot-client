require "rails_helper"

RSpec.describe LedgersController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/ledgers").to route_to("ledgers#index")
    end

    it "routes to #new" do
      expect(:get => "/ledgers/new").to route_to("ledgers#new")
    end

    it "routes to #show" do
      expect(:get => "/ledgers/1").to route_to("ledgers#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/ledgers/1/edit").to route_to("ledgers#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/ledgers").to route_to("ledgers#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/ledgers/1").to route_to("ledgers#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/ledgers/1").to route_to("ledgers#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/ledgers/1").to route_to("ledgers#destroy", :id => "1")
    end

  end
end
