class RegistrationsController < Devise::RegistrationsController
  before_filter :encrypt_passwords, only: [:create, :update]

  private
  def encrypt_passwords
    key = ActiveSupport::KeyGenerator.new(ENV["PASS"]).generate_key(ENV["SALT"])
    crypt = ActiveSupport::MessageEncryptor.new(key)

    if !params[:user][:cse_password].empty?
      params[:user][:cse_password] = crypt.encrypt_and_sign(params[:user][:cse_password])
    end

    if !params[:user][:ece_password].empty?
      params[:user][:ece_password] = crypt.encrypt_and_sign(params[:user][:ece_password])
    end
  end
end
