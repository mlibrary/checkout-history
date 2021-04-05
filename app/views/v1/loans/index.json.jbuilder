json.loans @loans do |loan|
  json.title loan.title
  json.author loan.author
  json.return_date loan.return_date
  json.checkout_date loan.checkout_date
  json.mms_id loan.mms_id
  json.barcode loan.barcode
  json.call_number loan.call_number
  json.description loan.description
end
json.total_record_count @loans.count
