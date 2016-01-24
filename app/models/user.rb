class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def has_cse_account?
    !(self.cse_username == "")
  end

  def has_ece_account?
    !(self.cse_username == "")
  end
end
