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
    @user = current_user
    @uploader = FileUploader.new
    if user_signed_in?
      @uploader.cache!(params[:user][:file])
    else
      @uploader.cache!(params[:guest][:file])
    end

    # Get the host, username, and password
    if user_signed_in?
      key = ActiveSupport::KeyGenerator.new(ENV["PASS"]).generate_key(ENV["SALT"])
      crypt = ActiveSupport::MessageEncryptor.new(key)

      if params[:user][:major]
        @host = ENV["#{params[:user][:major]}_HOST"]
        if params[:user][:major] == "CSE"
          @username = @user.cse_username
          @password = crypt.decrypt_and_verify(@user.cse_password)
        elsif params[:user][:major] == "ECE"
          @username = @user.ece_username
          @password = crypt.decrypt_and_verify(@user.ece_password)
        end
      else
        if @user.has_cse_account?
          @host = ENV["CSE_HOST"]
          @username = @user.cse_username
          @password = crypt.decrypt_and_verify(@user.cse_password)
        elsif @user.has_ece_account?
          @host = ENV["ECE_HOST"]
          @username = @user.ece_username
          @password = crypt.decrypt_and_verify(@user.ece_password)
        end
      end
    elsif params[:guest][:major]
      @host = ENV["#{params[:guest][:major]}_HOST"]
      @username = params[:guest][:username]
      @password = params[:guest][:password]
    end

    # Open up the ssh session
    Net::SSH.start(@host, @username, :password => @password) do |ssh|
      ssh.exec!("cd ~")
      @pwd = ssh.exec!("pwd")
      @pwd.strip!

      if ssh.exec!("ls | grep tmp_osuprinter").empty?
        ssh.exec!("mkdir tmp_osuprinter")
      end

      if @host == ENV["CSE_HOST"]
        @printers = ssh.exec!("lpstat -p -d | grep idle | cut -d' ' -f2").split("\n")
      elsif @host == ENV["ECE_HOST"]
        @printers = ssh.exec!("lpstat -p -d | grep idle | grep 'PayStation' -v | cut -d' ' -f2").split("\n")
      end

      @file_path = @uploader.full_cache_path
      @file_name = @file_path.split("/").last

      ssh.scp.upload!(@file_path, "#{@pwd}/tmp_osuprinter")

      if @file_path.split(".").last.downcase != "pdf"
        Net::SSH.start(@host, @username, :password => @password) do |ssh|
          ssh.exec!("libreoffice --invisible --convert-to pdf #{@pwd}/tmp_osuprinter/#{@file_name} --outdir #{@pwd}/tmp_osuprinter")
          ssh.exec!("rm -f #{@pwd}/tmp_osuprinter/#{@file_name}")
        end

        @file_name = @file_name.split(".")
        @file_name[@file_name.length - 1] = "pdf"
        @file_name = @file_name.join(".")
      end
    end

    cookies.signed[:printers] = @printers
    cookies.signed[:username] = @username
    cookies.signed[:password] = @password
    cookies.signed[:host] = @host
    cookies.signed[:file_name] = @file_name
    cookies.signed[:pwd] = @pwd

    redirect_to printer_options_path
  end

  # Method to get printer options from user (second form)
  def printer_options
    @printers = cookies.signed[:printers]
  end

  # Send the information to the printer
  def create
    puts params[:options]

    @command = "lp -d #{params[:options][:printer]}"

    if params[:options][:sides] == "Single Sided"
      @command << " -o \"sides=one-sided"
    elsif params[:options][:sides] == "Double Sided (long edge)"
      @command << " -o \"sides=two-sided-long-edge"
    elsif params[:options][:sides] == "Double Sided (short edge)"
      @command << " -o \"sides=two-sided-short-edge"
    end

    if params[:options][:orientation] == "Landscape"
      @command << " orientation-requested=4"
    else
      @command << " orientation-requested=3 number-up-layout=btlr"
    end

    if params[:options][:numberup] != 1
      @command << " number-up=#{params[:options][:numberup]}\""
    else
      @command << "\""
    end

    @command << " -n #{params[:options][:copies]}"
    @command << " tmp_osuprinter/#{cookies.signed[:file_name]}"

    puts @command

    Net::SSH.start(cookies.signed[:host], cookies.signed[:username], :password => cookies.signed[:password]) do |ssh|
      ssh.exec!(@command)
      ssh.exec!("rm -rf tmp_osuprinter/")
    end

    FileUtils.rm_rf("#{::Rails.root}/public/uploads/tmp")
    cookies.delete :printers
    cookies.delete :username
    cookies.delete :password
    cookies.delete :host
    cookies.delete :file_name
    cookies.delete :pwd
  end
end
