require 'rails_helper'

RSpec.describe "videos/index", type: :view do
  before(:each) do
    assign(:videos, [
      Video.create!(url: 'https://www.youtube.com/watch?v=fhnlIBmVk6I'),
      Video.create!(url: 'https://www.youtube.com/watch?v=T5L-pt9EnII')
    ])
  end

  it "renders a list of videos" do
    render
  end
end
