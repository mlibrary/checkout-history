class Loan < ApplicationRecord
  validates_uniqueness_of :id
  belongs_to :user, foreign_key: 'user_uniqname'
end
