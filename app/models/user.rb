class User < ApplicationRecord
  include BCrypt
  validates :login, presence: true, uniqueness: true
  validates :provider, presence: true

  has_one :access_token, dependent: :destroy
  has_many :articles, dependent: :destroy

  def password
    @password ||= Password.new(password_digest) if password_digest.present?
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_digest = @password
  end
end
