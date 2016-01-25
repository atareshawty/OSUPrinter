class FileUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    "uploads/"
  end

  def extension_white_list
    %w(xls xlsx doc docx ppt pptx pdf)
  end
end
