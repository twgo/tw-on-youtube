require 'rails_helper'
RSpec.describe DownloadWorker, type: :worker do
  before do
    @url = 'https://www.youtube.com/watch?v=W0jcK0CRKTY'
    @url2 = 'https://www.youtube.com/watch?v=IstxG6gapQM'
    @url3 = 'https://www.youtube.com/watch?v=7Ird1A7q_R8'
    @url4 = 'https://www.youtube.com/watch?v=zdbAL1J0SKM' # 簡繁英字幕

    @worker = DownloadWorker.new

    @video1 = Video.create(url: @url, status: 'video 1 downloading')
    @video2 = Video.create(url: @url2, status: 'video 2 downloading')
    @video3 = Video.create(url: @url3)
  end

  it 'download a video' do
    allow(@worker).to receive(:download_data)

    expect(@worker.perform(@url)).to eq "done: download video"
  end

  it 'return alert with wrong format input' do
    expect(@worker.youtube_dl_options('other_format')).to eq 'opus or mp4 format only'
  end

  context 'When download batch videos' do
    it 'download videos from list' do
      list_url = 'https://www.youtube.com/playlist?list=PLZiftgt33q3Oea2oVAErUDdtZy1gXO6Zi'
      allow(@worker).to receive(:create_worker)
      allow(@worker).to receive(:update_status_downloaded)

      expect(@worker.perform([list_url])).to eq 'done: download list/channel'
    end

    it 'download videos from channel' do
      channel_url = 'https://www.youtube.com/channel/UC4nqlRQN1XT_sExhXihxcQA'

      allow(@worker).to receive(:create_worker)
      allow(@worker).to receive(:update_status_downloaded)

      expect(@worker.perform([channel_url])).to eq 'done: download list/channel'
    end

    it 'ignore error while download list' do
      list_url = 'https://www.youtube.com/playlist?list=PLZiftgt33q3Oea2oVAErUDdtZy1gXO6Zi'

      allow(@worker).to receive(:run_youtube_dl).and_raise(RuntimeError)

      expect(@worker.youtube_dl_list([list_url],'mp4')).to eq "ignore youtube-dl.rb bug"
    end
  end

  context "when download_data with youtube-dl" do
    let(:video_status) {Video.find_by(url: @url).status}
    let(:video_path){'./public/download/mp4/BingAds/Bing Ads AAS 10 sec 01 052716-W0jcK0CRKTY.mp4'}
    let(:audio_path){'./public/download/opus/BingAds/Bing Ads AAS 10 sec 01 052716-W0jcK0CRKTY.opus'}
    let(:subtitle_path){'./public/download/mp4/BingAds/Bing Ads AAS 10 sec 01 052716-W0jcK0CRKTY.en.vtt'}

    it "raise error if youtube-dl not work" do
      allow(@worker).to receive(:run_youtube_dl).and_raise(RuntimeError)
      @worker.youtube_dl(@url, {})
      expect(video_status).to eq "Download Fail, YoutubeDL error: RuntimeError"
    end
    it "download a video: save, move, and log data" do
      @worker.download_data({data_formats: ['mp4', 'opus'], url: @url})

      expect(File.exist?("#{video_path}")).to eq true
      expect(File.exist?("#{audio_path}")).to eq true
      expect(File.exist?("#{subtitle_path}")).to eq true
    end
    it ".update_status_downloaded" do
      @worker.update_status_downloaded(@url3)
      expect(Video.find_by(url: @url3).status).to eq 'downloaded'
    end
    it ".create_worker" do
      allow(DownloadWorker).to receive(:perform_async).and_return('worker created')
      expect(@worker.create_worker(@url)).to eq 'worker created'
    end
    it ".update_format_downloaded" do
      @worker.update_format_downloaded(@url3, 'mp4')
      expect(Video.find_by(url: @url3).format_downloaded).to eq 'mp4 '
    end
    it ".update_subtitle_downloaded" do
      @worker.update_subtitle_downloaded(@url4, 'en')
      expect(Video.find_by(url: @url4).subtitle_downloaded).to eq 'en '
    end
  end
end
