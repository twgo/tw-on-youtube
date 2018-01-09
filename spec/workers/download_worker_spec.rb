require 'rails_helper'
RSpec.describe DownloadWorker, type: :worker do
  let(:載存影片){spy('get_corpus')}
  let(:載影片){spy('download_data')}
  let(:成功記錄){ 0 }
  let(:失敗記錄){ 0 }

  context '有掠corpus動作' do
    it '有跑載影片一次' do
      allow(載存影片).to receive(:載影片)
      載存影片
      expect(載存影片).to have_received(:載影片).once
    end
  end

  context '載影片進資料庫' do
    it '成功' do
      allow(載存影片).to receive(:載影片)
      expect(成功記錄).to eq 0
      載存影片
      expect(成功記錄).to eq 1
    end

    it '失敗' do
      allow(載存影片).to receive(:載影片)
      expect(失敗記錄).to eq 0
      載存影片
      expect(失敗記錄).to eq 1
    end
  end
end
