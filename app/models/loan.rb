class Loan < ApplicationRecord
  validates_uniqueness_of :id
  belongs_to :user, foreign_key: 'user_uniqname'

  def self.to_csv
    attributes = %w{mms_id title author description call_number barcode checkout_date return_date}
    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |loan|
        csv << attributes.map {|attr| loan.send(attr) }
      end
    end
  end
end
