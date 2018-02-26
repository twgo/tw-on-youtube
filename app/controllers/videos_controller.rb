class VideosController < ApplicationController
  before_action :set_video, only: [:show]

  def get_vtt
    send_file "#{Rails.root}/public/download/mp4/#{params[:u]}/#{params[:p]}.vtt" , type: 'text/plain; charset=utf-8'
  end

  # GET /videos
  # GET /videos.json
  def index
    @videos = Video.order(updated_at: :desc)
  end

  # GET /videos/1
  # GET /videos/1.json
  # def show
  #   @video = Video.find(params[:id])
  # end

  # GET /videos/new
  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_params)
    respond_to do |format|
      if @video.save
        Video.last.update(status: 'downloading')
        DownloadWorker.perform_async([@video.url])
        format.html { redirect_to videos_path, notice: 'Video download scheduled.' }
        format.json { render :show, status: :created, location: @video }
      else
        format.html { render :new }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end

  def redownload
    Video.find_by(url: params[:url]).update(status: 'downloading')
    DownloadWorker.perform_async([params[:url]])
    redirect_to videos_path, notice: 'Video redownload scheduled'
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def video_params
      params.require(:video).permit(
        :url,
      )
    end
end

# :status,
# :format_downloaded,
# :yid,
# :title,
# :thumbnail,
# :description,
# :duration,
# :filename,
# :uploader,
# :upload_date,
# :abr,
# :acodec,
# :tags,
# :location,
# :view_count,
# :like_count,
# :dislike_count,
# :repost_count,
# :average_rating,
# :comment_count,
# :age_limit,
# :autonumber,
# :playlist,
# :playlist_id,
# :playlist_title,
# :playlist_uploader,
# # :playlist_uploader_id,
