require 'rails_helper'

RSpec.describe VideosHelper, type: :helper do
  before do
    Video.create(url: 'url', status: 'downloading', filename: 'filename')
  end

  it 'return blanks while no files' do
    expect(file_link(Video.last)).to eq '  '
  end

  after do
    Video.last.delete
  end
end
