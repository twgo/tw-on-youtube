require 'rails_helper'
include ApplicationHelper

RSpec.describe VideosHelper, type: :helper do
  it 'return blanks while no files' do
    url = 'https://www.youtube.com/watch?v=fhnlIBmVk6I'
    Video.create(url: url, status: 'downloading', filename: 'filename', format_downloaded: 'mp4')
    expect(file_link(Video.find_by(url: url))).to eq ''
  end
end
