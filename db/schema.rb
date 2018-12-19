# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180104145920) do

  create_table "videos", force: :cascade do |t|
    t.string "url"
    t.string "status"
    t.string "format_downloaded"
    t.string "subtitle_downloaded"
    t.string "yid"
    t.string "title"
    t.string "thumbnail"
    t.string "description"
    t.string "duration"
    t.string "filename"
    t.string "uploader"
    t.string "uploader_id"
    t.string "upload_date"
    t.string "abr"
    t.string "acodec"
    t.string "tags"
    t.string "location"
    t.string "view_count"
    t.string "like_count"
    t.string "dislike_count"
    t.string "repost_count"
    t.string "average_rating"
    t.string "comment_count"
    t.string "age_limit"
    t.string "autonumber"
    t.string "playlist"
    t.string "playlist_id"
    t.string "playlist_title"
    t.string "playlist_uploader"
    t.string "playlist_uploader_id"
    t.string "channel"
    t.string "channel_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["url"], name: "index_videos_on_url"
    t.index ["yid"], name: "index_videos_on_yid"
  end

end
