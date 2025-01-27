class Role < ApplicationRecord
  # Associations
  has_and_belongs_to_many :users
  has_and_belongs_to_many :roles, join_table: :users_roles
end
