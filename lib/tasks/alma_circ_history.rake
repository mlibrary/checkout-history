require 'alma_rest_client'
namespace :alma_circ_history do
  desc "retrieves and loads latest circ history"
  task :load => :environment do
    Rails.logger.tagged('Circ Load') do
      Rails.logger.info('Started')
      client = AlmaRestClient.client
      puts "hiya"
      response = client.get_report(path: ENV.fetch('CIRC_REPORT_PATH'))
      if response.code != 200
        Rails.logger.error('Alma Report Failed to Load')
      end
      response.parsed_response.each do |row|
        begin
          u = User.find(row["Primary Identifier"].downcase)
        rescue
          Rails.logger.error("Uniqname not found: #{row["Primary Identifier"].downcase}")
          next
        end
        next unless u.retain_history
        loan = Loan.new do |l|
          l.user = u
          l.id = row["Item Loan Id"]
          l.title = row["Title"]
          l.author = row["Author"]
          l.mms_id = row["MMS Id"]
          l.return_date = row["Return Date"]
          l.checkout_date = row["Loan Date"]
          l.barcode = row["Barcode"]
          l.call_number = row["Call Number"]
          l.description = row["Description"]
        end
        if loan.save
          Rails.logger.info("item_loan '#{loan.id}' saved")
        else
          Rails.logger.warn("item_loan '#{loan.id}' not saved: #{loan.errors.full_messages}")
        end
      end
      Rails.logger.info('Finished')
    end
  end
  #task :test => :environment do
    #Rails.logger.tagged('testytest').info("????")
    #puts "hiya"
  #end
  #task :all => [:load, :notify]
end
