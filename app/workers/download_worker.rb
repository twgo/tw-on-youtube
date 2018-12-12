require 'fileutils'

class DownloadWorker
  include Sidekiq::Worker
  sidekiq_options retry: false
  DOCS_PATH = File.join(Rails.root, 'public', 'download')

  def perform(*args)
    url = args[0][0]
    params = {data_formats: ['mp4', 'wav'], url: url}
    if (url.include?('list=') || url.include?('/channel/'))
      list_url = url
      ['mp4', 'wav'].each do |data_format|
        yids_path = "public/download/#{data_format}-archive.txt"
        yids_before_dl = read_yids(yids_path)
        youtube_dl_list(list_url, data_format)
        yids_after_dl = read_yids(yids_path)
        yids = yids_after_dl - yids_before_dl
        ( yids.each { |yid| update_video_info(yid, data_format) } ) if yids.any?
      end
      update_status_downloaded(list_url)
      'done: download list/channel'
    else
      download_data(params)
      'done: download video'
    end
  end

  def download_data(params={})
    url = params[:url]
    data_formats = params[:data_formats]

    data_formats.each do |data_format|
      update_status_downloaded(url)
      youtube_dl(url, youtube_dl_options(data_format))
      update_format_downloaded(url, data_format)
    end
    'done: download_data'
  end

  def youtube_dl_options(data_format)
    if data_format == 'wav'
      {
      'extract-audio': true,
      'audio-format': 'wav',
      'audio-quality': 0,
      'output': 'public/download/%(ext)s/%(channel_id)s/%(channel_id)s%-(playlist_id)s-%(id)s.%(ext)s',
      'download-archive': 'public/download/wav-archive.txt',
      }
    elsif data_format == 'mp4'
      {
        'write-sub': true,
        'format': 'mp4',
        'sub-lang': 'zh-Hant,zh-Hans,en',
        'output': 'public/download/%(ext)s/%(channel_id)s/%(channel_id)s%-(playlist_id)s-%(id)s.%(ext)s',
        'download-archive': 'public/download/mp4-archive.txt',
      }
    else
      'wav or mp4 format only'
    end
  end

  def youtube_dl_list(list_url, data_format)
    options = youtube_dl_options(data_format)
    run_youtube_dl(list_url, options)
  rescue
    "ignore youtube-dl.rb bug"
  end

  def youtube_dl(url, options)
    data = run_youtube_dl(url, options)
    log_data(data, url)
    check_subtitle(data)
  rescue => e
    video = Video.find_by(url: url) || Video.create(url: url)
    video.update(status: "Download Fail, YoutubeDL error: #{e}")
  end

  def run_youtube_dl(url, options)
    YoutubeDL.download url, options
  end

  def	update_video_info(yid, data_format)
    url = "https://www.youtube.com/watch?v=#{yid}"
    params = {data_formats: ['mp4', 'wav'], url: url}
    download_data(params)
    'done: update_video_info'
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
    # uploader_id: data.uploader_id,

    'done: log_data'
  end

  def update_status_downloaded(url)
    video = Video.find_by(url: url) || Video.create(url: url)
    video.update_attributes(status: 'downloaded')
  end

  def update_format_downloaded(url, data_format)
    video = Video.find_by(url: url) || Video.create(url: url)
    formats = video.format_downloaded || ''
    video.update_attributes(format_downloaded: formats + "#{data_format} ") unless formats.include? (data_format)
  end

  def check_subtitle(data)
    vtts = Dir[File.join("public/download/mp4/#{data.uploader}/*.vtt")]
    url = data.url
    if vtts.any?
      vtts.each do |vtt|
        lang = vtt.split('.')[-2]
        update_subtitle_downloaded(url, lang)
      end
      update_format_downloaded(url, 'vtt')
    end
  end

  def update_subtitle_downloaded(url, lang)
    video = Video.find_by(url: url) || Video.create(url: url)
    vtts = video.subtitle_downloaded || ''
    video.update_attributes(subtitle_downloaded: vtts + "#{lang} ") unless vtts.include? (lang)
  end

  def read_yids(path)
    yids = []
    File.open(path, "r") do |f|
      f.each_line do |line|
        yids << (line.remove("youtube ").chomp)
      end
    end rescue nil
    yids
  end
end
