class User < ApplicationRecord
  has_many :loans, primary_key: 'uniqname', foreign_key: 'user_uniqname', dependent: :destroy

  before_update :set_confirmed
  before_update :purge_loans_if_opt_out

  def loans_page(limit: 10, offset: 0)
    loans.limit(limit).offset(offset)
  end
  def self.find_or_create_by_uniqname(uniqname)
    self.find_or_create_by(uniqname: uniqname.downcase) do |u|
      u.retain_history = true
      u.confirmed = false
    end
  end
  private
  def purge_loans_if_opt_out
    if !retain_history
      loans.destroy_all
    end
  end
  def set_confirmed
    self.confirmed = true
  end
end
