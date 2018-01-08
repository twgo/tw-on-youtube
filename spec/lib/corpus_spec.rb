require 'corpus'
RSpec.describe Corpus do
  let(:url) { 'https://www.youtube.com/watch?v=Oyio4UKLjLA' }

  before(:each) do
    extend Corpus
  end

  context '有掠corpus動作' do
    it do
        載存影片 = double('get_corpus', url: :url)
        allow(載存影片).to receive(:載影片){'掠corpus動作完成'}
        allow(載存影片).to receive(:存記錄){'存corpus動作完成'}
        expect(載存影片.載影片).to eq '掠corpus動作完成'
        expect(載存影片.存記錄).to eq '存corpus動作完成'
    end
  end

  context '載影片' do
    it '掠有' do
      下載影片 = double('download_data', url: :url)
      allow(下載影片).to receive(:水管下載){'掠有影片'}
      expect(下載影片.水管下載).to eq '掠有影片'
    end

    it '掠無' do
      下載影片 = double('download_data', url: :url)

      allow(下載影片).to receive(:水管下載){'掠無影片'}
      expect(下載影片.水管下載).to eq '掠無影片'
    end
  end
end
