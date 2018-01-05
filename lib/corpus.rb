module Corpus
  require 'youtube-dl.rb'

  def get_corpus(url)
    data = download_data(url)
    log_data(data)
  end

  def download_data(url)
  end

  def log_data(data)
  end
end
