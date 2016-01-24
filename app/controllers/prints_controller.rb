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
  end

  # Send the information to the printer
  def create
  end
end
