require "rails_helper"

RSpec.describe VideosController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/videos").to route_to("videos#index")
    end

    it "routes to #new" do
      expect(:get => "/videos/new").to route_to("videos#new")
    end

    it "routes to #create" do
      expect(:post => "/videos").to route_to("videos#create")
    end
  end
end
