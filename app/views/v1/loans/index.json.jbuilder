json.loans @loans do |loan|
  json.title loan.title
  json.author loan.author
  json.return_date loan.return_date
  json.checkout_date loan.checkout_date
  json.mms_id loan.mms_id
end
json.total_record_count @loans.count
