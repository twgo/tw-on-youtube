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
      t.string :upload_date

      t.timestamps
    end
  end
end
