require 'securerandom'
namespace :aleph_circ_history do
  desc "retrieves and loads latest circ history"
  task :load, [:path] => :environment do |t, args|
    Rails.logger.tagged('Aleph Circ Load') do
      Rails.logger.info('Started')
      CSV.foreach(args[:path], headers: true, col_sep: "\t" ) do |row|
        u = User.find_or_create_by_uniqname(row["Uniqname"], true) #default keep history for old users
        loan = Loan.new do |l|
          l.user = u
          l.id = SecureRandom.alphanumeric(16)
          l.title = row["Title"]
          l.author = row["Author"]
          l.mms_id = "99#{row["Aleph_sysnum"]}0206381"
          l.return_date = row["Return_date_time"]
          l.checkout_date = row["#Check_out_date_time"]
          l.barcode = row["Item_barcode"]
          l.call_number = row["Call_Number"]
          l.description = row["Volume_description"]
        end
        unless loan.save
          Rails.logger.warn("item_loan '#{loan.id}' not saved: #{loan.errors.full_messages}")
        end
      end
      Rails.logger.info('Finished')
    end
  end
end
