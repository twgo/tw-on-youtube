require 'rails_helper'
include ApplicationHelper

RSpec.describe VideosHelper, type: :helper do
  before do
    @url = 'https://www.youtube.com/watch?v=fhnlIBmVk6I'
  end
  it 'return blanks while no files' do
    Video.create(url: @url, status: 'downloading', filename: 'filename', format_downloaded: 'mp4', uploader_id: 'test_uid')
    expect(file_link(Video.find_by(url: @url))).to eq ''
  end
  it 'return vtt' do
    FileUtils.mkdir_p('public/download/vtt/test_uid')
    File.open("public/download/vtt/test_uid/test.vtt", 'a') {|f| f.write("test vtt") }
    Video.create(url: @url, status: 'downloading', filename: 'filename', format_downloaded: 'vtt', uploader_id: 'test_uid')
    expect(file_link(Video.find_by(url: @url))).to eq "<a target=\"_blank\" href=\"/videos/get_vtt?p=test&amp;u=test_uid\">test</a>"
    FileUtils.rm_rf(Dir.glob('public/download/vtt/test_uid/*'))
    FileUtils.rm_rf('public/download/vtt/test_uid/')
  end
end
