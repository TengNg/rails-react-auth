class User < ApplicationRecord
  include UuidPrimaryKey

  # Associations
  has_many :cards, dependent: :destroy
  has_and_belongs_to_many :roles, join_table: :users_roles, dependent: :destroy

  # Callbacks
  before_save :hash_password
  after_commit :assign_roles, on: :create, unless: -> { Rails.env.test? }
  after_commit :generate_initial_cards, on: :create, unless: -> { Rails.env.test? }

  # Validations
  validates :username, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }

  # Bcrypt validate password
  #
  # @param password [String] password to validate
  # @return [Boolean]
  def validate_password(password:)
    BCrypt::Password.new(self.password) == password
  rescue BCrypt::Errors::InvalidHash => e
    Rails.logger.error(e)
    false
  end

  def as_json
    { id:, username:, roles: role_names }
  end

  def admin?
    roles.pluck(:name).include?('admin')
  end

  def role_names
    roles.pluck(:name)
  end

  private

  def hash_password
    self.password = BCrypt::Password.create(self.password)
  end

  def assign_roles(roles = [1])
    self.role_ids = [1]
  end

  def generate_initial_cards(n = 3)
    create_payload = []
    n.times do |index|
      create_payload << {
        user_id: id,
        title: "Card #{index + 1}",
      }
    end

    Card.create(create_payload)
  end
end
