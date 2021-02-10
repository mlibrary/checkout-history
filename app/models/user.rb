class User < ApplicationRecord
  has_many :loans, primary_key: 'uniqname', foreign_key: 'user_uniqname'
end
