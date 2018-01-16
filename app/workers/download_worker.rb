require 'fileutils'

class DownloadWorker
  include Sidekiq::Worker
  sidekiq_options retry: false
  DOCS_PATH = File.join(Rails.root, 'public', 'download')

  def perform(*args)
    url = Video.last.url
    params = {data_formats: ['mp4', 'opus'], url: url}

    download_data(params)

    'done: get_corpus'
  end

  def download_data(params={})
    url = params[:url]
    data_formats = params[:data_formats]

    data_formats.each do |data_format|
      options = youtube_dl_options(data_format)

      data = youtube_dl(url, options)

      params = params.merge(data: data, data_format: data_format)
      move_files(params)
      log_data(data)
      update_status_downloaded
    end
    'done: download_data'
  end

  def youtube_dl_options(data_format)
    if data_format == 'opus'
      {
      'extract-audio': true,
      'audio-format': 'opus',
      'audio-quality': 0
      }
    elsif data_format == 'mp4'
      {
        'write-sub': true,
        'format': 'mp4',
        'sub-lang': 'zh-TW'
      }
    else
      'opus or mp4 format only'
    end
  end

  def youtube_dl(url, options)
    @result = YoutubeDL.download url, options
  rescue => e
    Video.order("updated_at DESC").find_by(url: url).update(status: "Download Fail, YoutubeDL error,#{e}")
  end

  def move_files(params={})
    data = params[:data]
    data_format = params[:data_format]
    move_file(params)
    move_file({data: data, data_format: 'vtt'}) if data_format == 'mp4'

    'done: move_files'
  end

  def	move_file(params={})
   data = params[:data]
   data_format = params[:data_format]
   @downloaded_files = Dir[File.join("*.#{data_format}")]
   @downloaded_files.each do |downloaded_filename|
     dirname = File.dirname("#{DOCS_PATH}/#{data_format}/#{data.uploader_id}")
     uploader_dirname = File.dirname("#{DOCS_PATH}/#{data_format}/#{data.uploader_id}/#{downloaded_filename}")
     FileUtils.mkdir_p(dirname)
     FileUtils.mkdir_p(uploader_dirname)
     FileUtils.mv("#{downloaded_filename}", "#{DOCS_PATH}/#{data_format}/#{data.uploader_id}/#{downloaded_filename}")
   end if @downloaded_files.any?
   'done: move_file'
  end

  def log_data(data)
    Video.last.update(
      yid: data.id,
      title: data.title,
      thumbnail: data.thumbnail,
      description: data.description,
      duration: data.duration,
      filename: data.filename,
      uploader: data.uploader,
      uploader_id: data.uploader_id,
      upload_date: data.upload_date,
      abr: data.abr,
      acodec: data.acodec,
      view_count: data.view_count,
      like_count: data.like_count,
      dislike_count: data.dislike_count,
      average_rating: data.average_rating,
      age_limit: data.age_limit,
    )
    # Not all video has..
    # repost_count: data.repost_count,
    # comment_count: data.comment_count,
    # location: data.location,
    # autonumber: data.autonumber,
    # playlist: data.playlist,
    # playlist_id: data.playlist_id,
    # playlist_title: data.playlist_title,
    # playlist_uploader: data.playlist_uploader,
    # playlist_uploader_id:	data.playlist_uploader_id,
    'done: log_data'
  end

  def update_status_downloaded
    Video.last.update(status: 'downloaded')
  end
end
