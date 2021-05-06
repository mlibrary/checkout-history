class AuthToken < ApplicationRecord
  validates_uniqueness_of :token, :name
end
