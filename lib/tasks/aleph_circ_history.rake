require 'alma_rest_client'
require 'securerandom'
namespace :aleph_circ_history do
  desc "retrieves and loads latest circ history"
  task :load, [:path] => :environment do |t, args|
    Rails.logger.tagged('Aleph Circ Load') do
      Rails.logger.info('Started')
      CSV.foreach(args[:path], headers: true, col_sep: "\t" ) do |row|
        u = User.find_or_create_by(uniqname: row["Uniqname"]) do |user|
          user.retain_history = true
          user.confirmed = false
          user.active = true
        end
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
      #client = AlmaRestClient.client
      #puts "hiya"
      #response = client.get_report(path: ENV.fetch('CIRC_REPORT_PATH'))
      #if response.code != 200
        #Rails.logger.error('Alma Report Failed to Load')
      #end
      #response.parsed_response.each do |row|
        #begin
          #u = User.find(row["Primary Identifier"].downcase)
        #rescue
          #Rails.logger.error("Uniqname not found: #{row["Primary Identifier"].downcase}")
          #next
        #end
        #next unless u.retain_history
        #loan = Loan.new do |l|
          #l.user = u
          #l.id = row["Item Loan Id"]
          #l.title = row["Title"]
          #l.author = row["Author"]
          #l.mms_id = row["MMS Id"]
          #l.return_date = row["Return Date"]
          #l.checkout_date = row["Loan Date"]
        #end
        #if loan.save
          #Rails.logger.info("item_loan '#{loan.id}' saved")
        #else
          #Rails.logger.warn("item_loan '#{loan.id}' not saved: #{loan.errors.full_messages}")
        #end
      #end
      Rails.logger.info('Finished')
    end
  end
  #task :test => :environment do
    #Rails.logger.tagged('testytest').info("????")
    #puts "hiya"
  #end
  #task :all => [:load, :notify]
end
