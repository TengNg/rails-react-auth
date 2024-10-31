class Card < ApplicationRecord
  include UuidPrimaryKey

  # Associations
  belongs_to :user

  # Validations
  validates :title, presence: true
end
