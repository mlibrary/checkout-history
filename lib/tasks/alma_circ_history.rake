require "alma_rest_client"
namespace :alma_circ_history do
  desc "retrieves and loads latest circ history"
  task load: :environment do
    summary = {active_loans: 0, loans_loaded: 0}
    Rails.logger.tagged("Circ Load") do
      Rails.logger.info("Started")
      Yabeda.checkout_history_load_last_success.set({}, Time.now.to_i)
      begin
        report_items = CheckoutHistoryLoader::Report.fetch
      rescue CheckoutHistoryLoader::FetchReportError => e
        Rails.logger.error("Alma Report Failed to Load: #{e}")
        exit
      end
      report_items.each do |report_item|
        summary[:active_loans] += 1
        begin
          CheckoutHistoryLoader::LoanLoader.load(report_item)
        rescue CheckoutHistoryLoader::LoanLoadError
          next
        end
        summary[:loans_loaded] += 1
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
      if response.status != 200
        Rails.logger.error("Alma Report Failed to Load")
        next
      end
      non_expired_users = response.body.map { |row| row["User Primary Identifier"].downcase }
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
