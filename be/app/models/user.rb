class User < ApplicationRecord
  include UuidPrimaryKey

  # Associations
  has_many :cards

  # Callbacks
  before_save :hash_password

  # Validations
  validates :username, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }

  # Bcrypt validate password
  # @param password [String] password to validate
  # @return [Boolean]
  def validate_password(password:)
    BCrypt::Password.new(self.password) == password
  rescue BCrypt::Errors::InvalidHash => e
    Rails.logger.error(e)
    false
  end

  def as_json
    { id:, username: }
  end

  private

  def hash_password
    self.password = BCrypt::Password.create(self.password)
  end
end
