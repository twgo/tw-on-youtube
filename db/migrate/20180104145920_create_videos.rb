# https://github.com/rg3/youtube-dl
class CreateVideos < ActiveRecord::Migration[5.1]
  def change
    create_table :videos do |t|
      t.string :url
      t.string :yid
      t.string :title
      t.string :thumbnail
      t.string :description
      t.string :duration
      t.string :filename
      t.string :uploader
      t.string :uploader_id
      t.string :upload_date
      t.string :abr
      t.string :acodec
      t.string :status
      t.string :tags
      t.string :location
      t.string :view_count
      t.string :like_count
      t.string :dislike_count
      t.string :repost_count
      t.string :average_rating
      t.string :comment_count
      t.string :age_limit
      t.string :autonumber
      t.string :playlist
      t.string :playlist_id
      t.string :playlist_title
      t.string :playlist_uploader
      t.string :playlist_uploader_id


      t.timestamps
    end

    add_index :videos, :url
  end
end
