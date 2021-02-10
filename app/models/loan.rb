class Loan < ApplicationRecord
  belongs_to :user, foreign_key: 'user_uniqname'
end
