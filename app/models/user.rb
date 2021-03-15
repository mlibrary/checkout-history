class User < ApplicationRecord
  has_many :loans, primary_key: 'uniqname', foreign_key: 'user_uniqname'

  before_update :set_confirmed
  before_update :set_active
  before_update :purge_loans_if_opt_out

  def loans_page(limit: 10, offset: 0)
    loans.limit(limit).offset(offset)
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
  def set_active
    self.active = true if self.confirmed == true
  end
end
