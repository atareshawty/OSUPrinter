class PrintsController < ApplicationController
  # Display the first form (grab the guest info and the file)
  def new
    if current_user
      @user = current_user
    end
  end

  # Method to handle file upload and store guest credentials
  # Get the printer choices here, too
  def file_upload
    @uploader = FileUploader.new
    if user_signed_in?
      @uploader.cache!(params[:user][:file])
    else
      @uploader.cache!(params[:guest][:file])
    end
    redirect_to root_path
  end

  # Method to get printer options from user (second form)
  def printer_options
  end

  # Send the information to the printer
  def create
  end
end
