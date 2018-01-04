module Corpus
  require 'youtube-dl.rb'

  def get_corpus(url)
    result='執行結果'
    srt=has_srt
    log_data(download_data(url, result), srt)
    'finished'
  end

  def download_data(url, result)
    tries = 3
    begin
      if (result=='多一個檔案')
        'success'
      elsif result == '重試失敗'
        retry_fail
      else
        'error'
      end
    rescue
      tries -= 1
      if tries > 0
        retry
      else
        'retry-error'
      end
    end
  end

  def log_data(data, srt)
    # Download.create();
    if (srt == '多一個字幕檔')
      'logged with subtitle'
    else
      'logged'
    end
  end

  def has_srt
    '有字幕'
  end
end
