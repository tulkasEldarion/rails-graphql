class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  before_create :generate_authentication_token!

  def generate_authentication_token!(replace: true)
    return unless replace
    loop do
      self.auth_token = Devise.friendly_token
      break self.class.exists?(auth_token: auth_token)
    end
  end
end
