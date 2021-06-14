#:nocov:
require 'faker'
namespace :dev do
  desc "seeds db with development data"
  task :seed => :environment do

    ['mlibrary.acct.testing1@gmail.com','mlibrary.acct.testing2@gmail.com', 'mlibrary.acct.testing3@gmail.com'].each do |uniqname|
      User.find_or_create_by(uniqname: uniqname) do |u| 
        u.retain_history = true
        u.confirmed = false
      end
      (1..35).each do
        Loan.create do |l|
          return_date =  Faker::Date.between(from: 2.years.ago, to: Date.today)
          l.user_uniqname = uniqname
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
  end
  task :reset do
    Rake::Task['db:migrate:reset'].invoke
  end
  task :all => [:reset, :seed]
end
#:nocov:
