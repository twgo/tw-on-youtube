module VideosHelper
  def file_link(video)
    data_formats = video.format_downloaded.split(' ')
    links = data_formats.map do |data_format|
      folder = "download/#{data_format}/#{video.channel_id}"
      path = File.join(Rails.root, 'public', 'download', "#{data_format}", "#{video.channel_id}")
      data_name = file_name video.filename
      if data_format == 'vtt'
        vtts = Dir["public/download/mp4/#{video.channel_id}/*.vtt"]
        vtts.map do |vtt|
          vtt_name = file_name vtt
          show_vtt = vtt_name.split('.')[-1]
          # link_to(show_vtt, "#{folder}/#{vtt_name}.vtt", target: '_blank')
          link_to(show_vtt, get_vtt_videos_path(p: vtt_name, u: video.channel_id), target: '_blank')
        end if vtts.any?
      else
        uploader_dirname = File.file?("#{path}/#{data_name}.#{data_format}")
        link_to(data_format, "#{folder}/#{data_name}.#{data_format}", target: '_blank') if uploader_dirname.present?
      end
    end
    links.join(' ').html_safe
  end
end
