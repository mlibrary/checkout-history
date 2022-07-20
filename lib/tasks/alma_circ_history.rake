require "alma_rest_client"
namespace :alma_circ_history do
  desc "retrieves and loads latest circ history"
  task load: :environment do
    summary = {active_loans: 0, loans_loaded: 0}
    Rails.logger.tagged("Circ Load") do
      Rails.logger.info("Started")
      Yabeda.checkout_history_load_last_success.set({}, Time.now.to_i)
      client = AlmaRestClient.client
      response = client.get_report(path: ENV.fetch("CIRC_REPORT_PATH"))
      if response.code != 200
        Rails.logger.error("Alma Report Failed to Load")
        next
      end
      summary[:active_loans] = response.parsed_response.count
      response.parsed_response.each do |row|
        u = User.find_or_create_by_uniqname(row["Primary Identifier"])
        unless u.retain_history
          Rails.logger.warn("item_loan '#{row["Item Loan Id"]}' not saved: patron opt out")
          next
        end
        loan = Loan.find_or_create_by(id: row["Item Loan Id"])
        next if loan.return_date.present? || loan.checkout_date&.to_date&.to_fs(:db) == row["Loan Date"]
       
        #mrio: using `tap` so I can use block syntax
        loan.tap do |l|
          l.user = u
          l.id = row["Item Loan Id"]
          l.title = row["Title"]&.slice(0, 255)
          l.author = row["Author"]&.slice(0, 255)
          l.mms_id = row["MMS Id"]
          l.return_date = row["Return Date"]
          l.checkout_date = row["Loan Date"]
          l.barcode = row["Barcode"]
          l.call_number = row["Call Number"]
          l.description = row["Description"]
        end
        if loan.save
          Rails.logger.info("item_loan '#{loan.id}' saved")
          summary[:loans_loaded] = summary[:loans_loaded] + 1
        else
          Rails.logger.warn("item_loan '#{loan.id}' not saved: #{loan.errors.full_messages}")
        end
      end
      Rails.logger.info("Finished")
      Rails.logger.info("Summary: #{summary}")
      Yabeda.checkout_history_num_items_loaded.set({}, summary[:loans_loaded])
      begin
        Yabeda::Prometheus.push_gateway.add(Yabeda::Prometheus.registry)
      rescue
        Rails.logger.error("Failed to contact the push gateway")
      end
    end
  end
  task purge: :environment do
    Rails.logger.tagged("Purge Expired Users") do
      Rails.logger.info("Started")
      client = AlmaRestClient.client
      response = client.get_report(path: ENV.fetch("PATRON_REPORT_PATH"))
      if response.code != 200
        Rails.logger.error("Alma Report Failed to Load")
        next
      end
      non_expired_users = response.parsed_response.map { |row| row["Primary Identifier"].downcase }
      User.all.each do |user|
        uniqname = user.uniqname
        if non_expired_users.include?(uniqname)
          Rails.logger.info("Retained User: #{uniqname}")
        else
          user.destroy
          Rails.logger.info("Deleted User: #{uniqname}")
        end
      end
      Rails.logger.info("Finished")
    end
  end
end
