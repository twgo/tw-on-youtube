require 'corpus'
RSpec.describe Corpus do
  let(:url) { 'https://www.youtube.com/watch?v=Oyio4UKLjLA' }

  before(:each) do
    extend Corpus
  end

  context '有掠corpus' do
    it do
        下載 = spy('corpus')
        下載.download_data(url)
        下載.to have_received(:download).with(url)
    end
  end

  context '掠corpus' do
    it '掠有' do
      下載 = spy('corpus')
      allow(下載).to receive(:download_data).with(url).and_return('掠影片成功')
      expect(下載.download_data(url)).to eq '掠影片成功'
    end

    it '掠無' do
      下載=spy('corpus')
      allow(下載).to receive(:download_data).with(url).and_raise('掠影片失敗')
      expect{下載.download_data(url)}.to raise_error '掠影片失敗'
    end
  end

  context '掠字幕' do
    it '掠有' do
      下載=spy('corpus')
      allow(下載).to receive(:has_cc).and_return('字幕掠有')
      expect(下載.has_cc).to eq '字幕掠有'
    end
    it '掠無' do
      下載=spy('corpus')
      allow(下載).to receive(:has_cc).and_return('字幕掠無')
      expect(下載.has_cc).to eq '字幕掠無'
    end
  end
end
