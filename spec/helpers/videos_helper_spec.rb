require 'rails_helper'

RSpec.describe VideosHelper, type: :helper do
  it 'return blanks while no files' do
    Video.create(url: 'url', status: 'downloading', filename: 'filename')
    expect(file_link(Video.last)).to eq '  '
  end
end
