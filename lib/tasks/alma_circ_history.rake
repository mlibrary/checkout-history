require 'alma_rest_client'
namespace :alma_circ_history do
  desc "retrieves and loads latest circ history"
  task :load => :environment do
    client = AlmaRestClient.client
    response = client.get_report(path: ENV.fetch('CIRC_REPORT_PATH'))
    #TODO error handling for response.code != 200 
    response.parsed_response.each do |row|
      begin
        u = User.find(row["Primary Identifier"].downcase)
      rescue
        #should log this
        next
      end
      next unless u.retain_history
      loan = Loan.create do |l|
        l.user = u
        l.id = row["Item Loan Id"]
        l.title = row["Title"]
        l.author = row["Author"]
        l.mms_id = row["MMS Id"]
        l.return_date = row["Return Date"]
        l.checkout_date = row["Loan Date"]
      end
    end
  end
  #task :notify do
  #end
  #task :all => [:load, :notify]
end
