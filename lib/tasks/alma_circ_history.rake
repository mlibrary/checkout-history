require 'alma_rest_client'
namespace :alma_circ_history do
  desc "retrieves and loads latest circ history"
  task :load => :environment do
    Rails.logger.tagged('Circ Load') do
      Rails.logger.info('Started')
      client = AlmaRestClient.client
      response = client.get_report(path: ENV.fetch('CIRC_REPORT_PATH'))
      if response.code != 200
        Rails.logger.error('Alma Report Failed to Load')
        next
      end
      response.parsed_response.each do |row|
        u = User.find_or_create_by_uniqname(row["Primary Identifier"])
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
  task :purge => :environment do
    Rails.logger.tagged('Purge Expired Users') do
      Rails.logger.info('Started')
      client = AlmaRestClient.client
      response = client.get_report(path: ENV.fetch('PATRON_REPORT_PATH'))
      if response.code != 200
        Rails.logger.error('Alma Report Failed to Load')
        next
      end
      non_expired_users = response.parsed_response.map { |row| row["Primary Identifier"].downcase }
      User.all.each do |user|
        uniqname = user.uniqname
        if non_expired_users.include?(uniqname)
          Rails.logger.info('Retained User: #{uniqname}')
        else
          user.destroy
          Rails.logger.info('Deleted User: #{uniqname}')
        end
      end
      Rails.logger.info('Finished')
    end
  end
end
