class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validate :at_least_one_username
  validate :matching_password

  def has_cse_account?
    !(self.cse_username == "")
  end

  def has_ece_account?
    !(self.cse_username == "")
  end

  private
  def at_least_one_username
    if [self.cse_username, self.ece_username].reject(&:blank?).size == 0
      errors[:base] << ("Please enter at least one username.")
    end
  end

  def matching_password
    if self.cse_username.length > 0 && self.cse_password.length == 0
      errors[:cse_password] << ("Please enter a password for your CSE username.")
    elsif self.ece_username.length > 0 && self.ece_password.length == 0
      errors[:ece_password] << ("Please enter a password for your ECE username.")
    end
  end
end
