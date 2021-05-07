class AuthToken < ApplicationRecord
  has_secure_token length: 36
  validates_uniqueness_of :token, :name
end
