#:nocov:
require 'faker'
namespace :dev do
  desc "seeds db with development data"
  task :seed => :environment do
    User.create(uniqname: 'ajones',retain_history: true, confirmed: true)
    User.create(uniqname: 'emcard',retain_history: true, confirmed: true)
    (1..35).each do
      Loan.create do |l|
        return_date =  Faker::Date.between(from: 2.years.ago, to: Date.today)
        l.user_uniqname = 'emcard'
        l.id = SecureRandom.alphanumeric(16)
        l.title = Faker::Book.title
        l.author = Faker::Book.author
        l.mms_id = "99#{Faker::Number.number(digits: 12)}6381"
        l.return_date = return_date
        l.checkout_date = return_date - rand(0..50).days
        l.barcode = Faker::Number.number(digits: 16)
        l.call_number = "call number"
        l.description = '' 
      end
    end
  end
  task :reset do
    Rake::Task['db:migrate:reset'].invoke
  end
  task :all => [:reset, :seed]
end
#:nocov:
