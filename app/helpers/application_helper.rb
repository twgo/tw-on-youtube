module ApplicationHelper
  def file_name(path)
    File.basename(path, (File.extname path))
  end
end
