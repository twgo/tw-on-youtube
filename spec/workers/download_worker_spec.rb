require 'rails_helper'
RSpec.describe DownloadWorker, type: :worker do
  before do
    @url = 'https://www.youtube.com/watch?v=W0jcK0CRKTY'
    @url2 = 'https://www.youtube.com/watch?v=IstxG6gapQM'
    @url3 = 'https://www.youtube.com/watch?v=7Ird1A7q_R8'
    @url4 = 'https://www.youtube.com/watch?v=zdbAL1J0SKM' # 簡繁英字幕
    @list_url = 'https://www.youtube.com/playlist?list=PLZiftgt33q3Oea2oVAErUDdtZy1gXO6Zi'

    @params = {data: 'youtube_dl_data', data_formats: ['mp4', 'opus'], url: @url}
    @worker = DownloadWorker.new

    @video1 = Video.create(url: @url, status: 'video 1 downloading')
    @video2 = Video.create(url: @url2, status: 'video 2 downloading')
    @video3 = Video.create(url: @url3)
    @video4 = Video.create(url: @url4)
  end

  it 'download a video' do
    allow(@worker).to receive(:download_data)

    expect(@worker.perform(@url)).to eq "done: download video"
  end

  it 'download videos' do
    allow(@worker).to receive(:create_woker)
    allow(@worker).to receive(:update_status_downloaded)

    expect(@worker.perform([@list_url])).to eq "done: create video_list worker"
  end

  context '.youtube_dl_options' do
    it 'return video options' do
      expect(@worker.youtube_dl_options('mp4')).to eq({
        'write-sub': true,
        'format': 'mp4',
        'sub-lang': 'zh-Hant,zh-Hans,en'
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

  context "when download_data with youtube-dl" do
    let(:video_status) {Video.find_by(url: @url).status}
    let(:video_path){'./public/download/mp4/BingAds/Bing Ads AAS 10 sec 01 052716-W0jcK0CRKTY.mp4'}
    let(:audio_path){'./public/download/opus/BingAds/Bing Ads AAS 10 sec 01 052716-W0jcK0CRKTY.opus'}
    let(:subtitle_path){'./public/download/vtt/BingAds/Bing Ads AAS 10 sec 01 052716-W0jcK0CRKTY.en.vtt'}

    it "raise error if youtube-dl not work" do
      allow(@worker).to receive(:run_youtube_dl).and_raise(RuntimeError)
      @worker.youtube_dl(@url, {})
      expect(video_status).to eq "Download Fail, YoutubeDL error: RuntimeError"
    end
    it "download a video: save, move, and log data" do
      @worker.download_data(@params)

      expect(Dir[File.join("*.mp4")]).to eq []
      expect(Dir[File.join("*.opus")]).to eq []
      expect(Dir[File.join("*.vtt")]).to eq []
      expect(File.exist?("#{video_path}")).to eq true
      expect(File.exist?("#{audio_path}")).to eq true
      expect(File.exist?("#{subtitle_path}")).to eq true

      expect(video_status).to eq "downloaded"
    end
    it ".update_format_downloaded" do
      @worker.update_format_downloaded(@url3, 'mp4')
      expect(Video.find_by(url: @url3).format_downloaded).to eq 'mp4 '
    end
    it ".update_subtitle_downloaded" do
      @worker.update_subtitle_downloaded(@url4, 'en')
      expect(Video.find_by(url: @url4).subtitle_downloaded).to eq 'en '
    end
    it ".create_worker" do
      allow(DownloadWorker).to receive(:perform_async).and_return('worker created')
      expect(@worker.create_woker(@url)).to eq 'worker created'
    end
  end
end
