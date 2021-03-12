#:nocov:
namespace :dev do
  desc "seeds db with development data"
  task :seed => :environment do
    User.create(uniqname: 'ajones',retain_history: true, confirmed: true)
    User.create(uniqname: 'emcard',retain_history: true, confirmed: true)
  end
  task :reset do
    Rake::Task['db:migrate:reset'].invoke
  end
  task :all => [:reset, :seed]
end
#:nocov:
