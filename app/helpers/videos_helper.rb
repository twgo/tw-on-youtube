module VideosHelper
  def file_link(video)
    path = File.join(Rails.root, 'public', 'download')
    links = ['mp4', 'opus', 'vtt'].map do |suffix|
      file_name = (File.basename(video.filename, (File.extname video.filename)))
      if suffix == 'vtt'
        uploader_dirname = File.file?("#{path}/#{suffix}/#{video.uploader_id}/#{file_name}.zh-TW.#{suffix}")
        link_to(suffix, "download/#{suffix}/#{video.uploader_id}/#{file_name}.zh-TW.#{suffix}", target: '_blank') if uploader_dirname.present?
      else
        uploader_dirname = File.file?("#{path}/#{suffix}/#{video.uploader_id}/#{file_name}.#{suffix}")
        link_to(suffix, "download/#{suffix}/#{video.uploader_id}/#{file_name}.#{suffix}", target: '_blank') if uploader_dirname.present?
      end
    end
    links.join(' ').html_safe
  end
end
