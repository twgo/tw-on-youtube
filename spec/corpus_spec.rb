require '../lib/corpus'
RSpec.describe Corpus do
  let(:url) { 'https://www.youtube.com/watch?v=Oyio4UKLjLA' }

  before(:each) do
    extend Corpus
  end

  context 'Can run all works to get corpus' do
    it { expect(get_corpus(url)).to eq 'finished'  }
  end

  context '掠有corpus' do
    it { expect(download_data(url, '多一個檔案')).to eq 'success'   }
  end

  context '掠無corpus' do
    it { expect(download_data(url, '沒多一個檔案')).to eq 'error'   }
  end

  context '掠有字幕' do
    it { expect(log_data('下載結果', '多一個字幕檔')).to eq 'logged with subtitle'   }
  end

  context '掠無字幕' do
    it { expect(log_data('下載結果', '沒多一個字幕檔')).to eq 'logged'   }
  end
end
