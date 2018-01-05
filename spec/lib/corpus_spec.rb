require 'corpus'
RSpec.describe Corpus do
  let(:url) { 'https://www.youtube.com/watch?v=Oyio4UKLjLA' }

  before(:each) do
    extend Corpus
  end

  context '有掠corpus動作' do
    it do
        下載 = spy('youtube-dl')
        存檔 = spy('log_data')
        allow(下載).to receive(:message){'掠corpus動作完成'}
        allow(存檔).to receive(:message){'存corpus動作完成'}
        expect(get_corpus(url)).to eq '執行完成'
    end
  end

  context '掠影片' do
    it '掠有' do
      下載 = spy('youtube-dl')
      allow(下載).to receive(:message){'掠有影片'}
      expect(download_data(url)).to eq '掠影片成功'
    end

    it '掠無' do
      下載 = spy('youtube-dl')
      allow(下載).to receive(:message){'掠無影片'}
      expect{download_data(url)}.to raise_error '掠影片失敗'
    end
  end

  context '掠字幕' do
    it '掠有' do
      下載字幕 = spy('youtube-dl-cc')
      allow(下載字幕).to receive(:message){'字幕掠有'}
      expect(has_cc(下載字幕)).to eq '字幕掠成功'
    end
    it '掠無' do
      下載字幕 = spy('youtube-dl-cc')
      allow(下載字幕).to receive(:message){'字幕掠無'}
      expect(has_cc(下載字幕)).to eq '字幕掠失敗'
    end
  end

  context '掠聲音' do
    it '掠有' do
      下載聲音 = spy('youtube-dl-audio')
      allow(下載聲音).to receive(:message){'聲音掠有'}
      expect(has_audio(下載聲音)).to eq '聲音掠成功'
    end
    it '掠無' do
      下載聲音 = spy('youtube-dl-audio')
      allow(下載聲音).to receive(:message){'聲音掠無'}
      expect(has_audio(下載聲音)).to eq '聲音掠失敗'
    end
  end
end
