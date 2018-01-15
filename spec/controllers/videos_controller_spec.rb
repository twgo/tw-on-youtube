require 'rails_helper'
RSpec.describe VideosController, type: :controller do
  describe "GET #index" do
    it "returns a success response" do
      get :index
      expect(response).to be_success
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new
      expect(response).to be_success
    end
  end

  describe "POST #create" do
    it "returns a ParameterMissing response" do
      expect{ post(:create, {}) }.to raise_error ActionController::ParameterMissing
    end
  end
end
