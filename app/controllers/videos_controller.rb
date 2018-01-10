class VideosController < ApplicationController
  before_action :set_video, only: [:show]

  # GET /videos
  # GET /videos.json
  def index
    @videos = Video.order(updated_at: :desc)
  end

  # GET /videos/1
  # GET /videos/1.json
  def show
    @video = Video.find(params[:id])
  end

  # GET /videos/new
  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_params)

    respond_to do |format|
      if @video.save
        DownloadWorker.perform_async
        Video.last.update(status: 'downloading')
        format.html { redirect_to videos_path, notice: 'Video was successfully created.' }
        format.json { render :show, status: :created, location: @video }
      else
        format.html { render :new }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def video_params
      params.require(:video).permit(
        :url,
        :yid,
        :title,
        :thumbnail,
        :description,
        :duration,
        :filename,
        :uploader,
        :upload_date,
        :abr,
        :acodec,
        :status,
        :tags,
        :location,
        :view_count,
        :like_count,
        :dislike_count,
        :repost_count,
        :average_rating,
        :comment_count,
        :age_limit,
        :autonumber,
        :playlist,
        :playlist_id,
        :playlist_title,
        :playlist_uploader,
        :playlist_uploader_id,
      )
    end
end
