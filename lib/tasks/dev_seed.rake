namespace :dev do
  desc "seeds db with development data"
  task :seed => :environment do
    User.create(uniqname: 'mrio',retain_history: true, confirmed: true)
    Loan.create(uniqname: 'mrio', id: '8797507940006381', mms_id: '990004538640206000', title: 'Editing early music /', author: 'Caldwell, John, 1938-', checkout_date: '2021-02-08', return_date: '2021-02-08')
  end
  task :reset do
    Rake::Task['db:migrate:reset'].invoke
  end
  task :all => [:reset, :seed]
end
