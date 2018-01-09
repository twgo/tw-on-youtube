require 'fileutils'

class DownloadWorker
  include Sidekiq::Worker
  sidekiq_options retry: false
  DOCS_PATH = File.join(Rails.root, "public")

  def perform(*args)
    # Do something
    url = Video.last.url
    get_corpus(url)
  end

  def get_corpus(url)
    data = download_data(url)
    data_format = data.filename.split('.').last
    log_data(data)

    dirname = File.dirname("#{DOCS_PATH}/#{data_format}/#{data.uploader}")
    unless File.directory?(dirname)
      FileUtils.mkdir_p(dirname)
    end
    uploadername = File.dirname("#{DOCS_PATH}/#{data_format}/#{data.uploader}/#{data.filename}")
    unless File.directory?(uploadername)
      FileUtils.mkdir_p(uploadername)
    end
    FileUtils.mv("#{data.filename}", "#{DOCS_PATH}/#{data_format}/#{data.uploader}/#{data.filename}")
  end

  def download_data(url)
    options = {
      format: 'mp4'
    }

    YoutubeDL.download url, options
  end

  def log_data(data)
    Video.find_by(url: data.url).update(
      status: 'downloaded',
      yid: data.id,
      title: data.title,
      thumbnail: data.thumbnail,
      description: data.description,
      duration: data.duration,
      filename: data.filename,
      uploader: data.uploader,
      upload_date: data.upload_date,
    )
  end
end
