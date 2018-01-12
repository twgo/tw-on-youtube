require 'rails_helper'
RSpec.describe DownloadWorker, type: :worker do
  before do
    @url = 'https://www.youtube.com/watch?v=w5C7S0FlSyM'
    @params = {data: 'youtube_dl_data', data_formats: ['mp4', 'opus'], url: @url}
    @worker = DownloadWorker.new

    Video.create(url: 'url', status: 'downloading')
  end

  it 'run download_data once' do
    allow(@worker).to receive(:download_data)

    expect(@worker.perform).to eq "done: get_corpus"
  end

  it '.download_data' do
    allow(@worker).to receive(:youtube_dl)
    allow(@worker).to receive(:move_files)
    allow(@worker).to receive(:log_data)

    @worker.download_data(@params)
    expect(Video.last.status).to eq "downloaded"
  end

  context '.move_files' do
    before do
      @worker.move_files.instance_variable_set(:@downloaded_files, ['1.mp4', '2.opus', '3.vtt'])
      @worker.move_files({data_formats: ['mp4', 'opus']})
    end

    it 'wont leave mp4' do expect(Dir[File.join("*.mp4")]).to eq [] end
    it 'wont leave opus' do expect(Dir[File.join("*.opus")]).to eq [] end
    it 'wont leave vtt' do expect(Dir[File.join("*.vtt")]).to eq [] end
  end

  context '.youtube_dl_options' do
    it 'return video options' do
      expect(@worker.youtube_dl_options('mp4')).to eq({
        'write-sub': true,
        'format': 'mp4',
        'sub-lang': 'zh-TW'
         })
    end
    it 'return audio options' do
      expect(@worker.youtube_dl_options('opus')).to eq({
        'extract-audio': true,
        'audio-format': 'opus',
        'audio-quality': 0
        })
    end
  end

  after do
    Video.last.delete
  end
end
