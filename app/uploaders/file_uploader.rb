class FileUploader < CarrierWave::Uploader::Base
  include CarrierWave::Uploader::Cache
  storage :file

  def store_dir
    "uploads/"
  end

  def extension_white_list
    %w(xls xlsx doc docx ppt pptx pdf)
  end
end

module CarrierWave::Uploader::Cache
  def full_cache_path
    "#{::Rails.root}/public/#{cache_dir}/#{cache_name}"
  end
end
