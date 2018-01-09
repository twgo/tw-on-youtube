class DownloadWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(*args)
    # Do something
    url = Video.last.url
    get_corpus(url)
  end

  def get_corpus(url)
    data = download_data(url)
    log_data(data)
  end

  def download_data(url)
    YoutubeDL.download url
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
