class User < ApplicationRecord
  include BCrypt
  validates :login, presence: true, uniqueness: true
  validates :provider, presence: true
  validates :password, presence: true, if: -> {provider=="standard"}

  has_one :access_token, dependent: :destroy
  has_many :articles, dependent: :destroy

  def password
    @password ||= Password.new(password_digest) if password_digest.present?
  end

  def password=(new_password)
    return @password = new_password if new_password.blank?
    @password = Password.create(new_password)
    self.password_digest = @password
  end
end
