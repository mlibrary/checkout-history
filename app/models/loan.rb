class Loan < ApplicationRecord
  belongs_to :user, foreign_key: 'uniqname'
end
