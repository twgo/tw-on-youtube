require 'rails_helper'
RSpec.describe DownloadWorker, type: :worker do
  before do
    @url = 'https://www.youtube.com/watch?v=w5C7S0FlSyM'
    @params = {data: 'youtube_dl_data', data_formats: ['mp4', 'opus'], url: @url}
    @worker = DownloadWorker.new

    Video.create(url: @url, status: 'downloading')
  end

  it 'run download_data once' do
    allow(@worker).to receive(:download_data)

    expect(@worker.perform).to eq "done: get_corpus"
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
    it 'return alert with wrong format input' do
      expect(@worker.youtube_dl_options('other_format')).to eq 'opus or mp4 format only'
    end
  end

  context "when youtube-dl" do
    it "raise error if youtube-dl not work" do
      allow(@worker).to receive(:run_youtube_dl).and_raise(RuntimeError)
      @worker.youtube_dl(@url, {})
      expect(Video.order("updated_at DESC").find_by(url: @url).status).to eq "Download Fail, YoutubeDL error: RuntimeError"
    end
  end

  context 'when download_data' do
    it "download, move, and log data" do
      # @worker.download_data(@params)
      # expect(Video.order("updated_at DESC").find_by(url: @url).status).to eq "downloaded"
    end
  end
end
