require 'rails_helper'
RSpec.describe DownloadWorker, type: :worker do
  before do
    @url = 'https://www.youtube.com/watch?v=PTox4Froo4Q'
    @params = {data_formats: ['mp4', 'opus'], url: @url}
    @worker = DownloadWorker.new
  end

  it '.get_corpus' do
    allow(@worker).to receive(:download_data)
    expect(@worker.get_corpus(@url)).to eq "done: get_corpus"
  end

  it '.download_data' do
    allow(@worker).to receive(:youtube_dl)
    allow(@worker).to receive(:move_files)
    allow(@worker).to receive(:log_data)

    expect(@worker.download_data(@params)).to eq "done: download_data"
  end
end
