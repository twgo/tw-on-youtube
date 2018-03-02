require 'rails_helper'
include ApplicationHelper

RSpec.describe VideosHelper, type: :helper do
  before do
    @url = 'https://www.youtube.com/watch?v=fhnlIBmVk6I'
  end
  it 'return blanks while no files' do
    Video.create(url: @url, status: 'downloading', filename: 'filename', format_downloaded: 'mp4', uploader: 'test_uploader')
    expect(file_link(Video.find_by(url: @url))).to eq ''
  end
  it 'return vtt' do
    FileUtils.mkdir_p('public/download/mp4/test_uploader')
    File.open("public/download/mp4/test_uploader/test.vtt", 'a') {|f| f.write("test vtt") }
    Video.create(url: @url, status: 'downloading', filename: 'filename', format_downloaded: 'vtt', uploader: 'test_uploader')
    expect(file_link(Video.find_by(url: @url))).to eq "<a target=\"_blank\" href=\"/videos/get_vtt?p=test&amp;u=test_uploader\">test</a>"
    FileUtils.rm_rf(Dir.glob('public/download/mp4/test_uploader/*'))
    FileUtils.rm_rf('public/download/mp4/test_uploader/')
  end
end
