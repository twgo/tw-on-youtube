require 'fileutils'

class DownloadWorker
  include Sidekiq::Worker
  sidekiq_options retry: false
  DOCS_PATH = File.join(Rails.root, 'public', 'download')

  def perform(*args)
    url = args[0][0]
    params = {data_formats: ['opus', 'mp4'], url: url}
    if (url.include?('list=') || url.include?('/channel/'))
      list_url = url

      ['opus', 'mp4'].each { |data_format| youtube_dl_list(list_url, data_format)}

      update_status_downloaded(list_url)
      'done: download list/channel'
    else
      download_data(params)
      'done: download video'
    end
  end

  def create_worker(video_url)
    DownloadWorker.perform_async([video_url])
  end

  def download_data(params={})
    url = params[:url]
    data_formats = params[:data_formats]

    data_formats.each do |data_format|
      options = youtube_dl_options(data_format)
      youtube_dl(url, options)
    end
    'done: download_data'
  end

  def youtube_dl_options(data_format)
    if data_format == 'opus'
      {
      'extract-audio': true,
      'audio-format': 'opus',
      'audio-quality': 0,
      'output': 'public/download/opus/%(uploader_id)s/%(title)s-%(id)s.%(ext)s',
      'download-archive': 'public/download/opus-archive.txt'
      }
    elsif data_format == 'mp4'
      {
        'write-sub': true,
        'format': 'mp4',
        'sub-lang': 'zh-Hant,zh-Hans,en',
        'output': 'public/download/mp4/%(uploader_id)s/%(title)s-%(id)s.%(ext)s',
        'download-archive': 'public/download/mp4-archive.txt'
      }
    else
      'opus or mp4 format only'
    end
  end

  def youtube_dl_list(list_url, data_format)
    run_youtube_dl(list_url, youtube_dl_options(data_format))
  rescue
    "ignore youtube-dl.rb bug"
  end

  def youtube_dl(url, options)
    run_youtube_dl(url, options)
    log_data(data, url)
    update_status_downloaded(url)
  rescue => e
    Video.find_by(url: url).update(status: "Download Fail, YoutubeDL error: #{e}")
  end

  def run_youtube_dl(url, options)
    YoutubeDL.download url, options
  end

  def log_data(data, url)
    Video.find_by(url: url).update(
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
      age_limit: data.age_limit,
    )
    # Not all video has..
    # like_count: data.like_count,
    # dislike_count: data.dislike_count,
    # repost_count: data.repost_count,
    # comment_count: data.comment_count,
    # average_rating: data.average_rating,
    # location: data.location,
    # autonumber: data.autonumber,
    # playlist: data.playlist,
    # playlist_id: data.playlist_id,
    # playlist_title: data.playlist_title,
    # playlist_uploader: data.playlist_uploader,
    # playlist_uploader_id:	data.playlist_uploader_id,
    'done: log_data'
  end

  def update_status_downloaded(url)
    Video.find_by(url: url).update(status: 'downloaded')
  end

  def update_format_downloaded(url, data_format)
    video = Video.find_by(url: url)
    formats = video.format_downloaded || ''
    video.update_attributes(format_downloaded: formats + "#{data_format} ")
  end

  def update_subtitle_downloaded(url, lang)
    video = Video.find_by(url: url)
    vtts = video.subtitle_downloaded || ''
    video.update_attributes(subtitle_downloaded: vtts + "#{lang} ")
  end
end
