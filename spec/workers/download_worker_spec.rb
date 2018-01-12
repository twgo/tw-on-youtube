require 'rails_helper'
RSpec.describe DownloadWorker, type: :worker do
  before do
    @url = 'https://www.youtube.com/watch?v=PTox4Froo4Q'
    @params = {data: 'youtube_dl_data', data_formats: ['mp4', 'opus'], url: @url}
    @worker = DownloadWorker.new
    Video.create(url: 'url', status: 'downloading')
  end

  after do
    Video.last.delete
  end

  it '.get_corpus' do
    allow(@worker).to receive(:download_data)

    expect(@worker.get_corpus(@url)).to eq "done: get_corpus"
  end

  it '.download_data' do
    allow(@worker).to receive(:youtube_dl)
    allow(@worker).to receive(:move_files)
    allow(@worker).to receive(:log_data)
    @worker.download_data(@params)
    expect(Video.last.status).to eq "downloaded"
  end

  context '.move_files' do
    it 'wont leave mp4' do expect(Dir[File.join("*.mp4")]).to eq [] end
    it 'wont leave opus' do expect(Dir[File.join("*.opus")]).to eq [] end
    it 'wont leave vtt' do expect(Dir[File.join("*.vtt")]).to eq [] end
  end
end
