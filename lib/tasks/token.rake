require 'securerandom'
namespace :token do
  desc "generates a new token with associated name"
  task :generate, [:name] => :environment do |t, args|
    a = AuthToken.new(name: args[:name])
    unless (a.save)
      puts "Errors: #{a.errors.full_messages.join('; ')}"
    else
      puts "token: #{a.token} for app: #{a.name}"
    end
  end
  desc "regenerates token for app name" 
  task :regenerate, [:name] => :environment do |t, args|
    a = AuthToken.find_by(name: args[:name])
    if a.nil?
      puts "Error: app: '#{args[:name]}' does not exist"
    else
      unless (a.regenerate_token)
        puts "Errors: #{a.errors.full_messages.join('; ')}"
      else
        puts "token: #{a.token} for app: #{a.name}"
      end
    end
  end
  desc "gets token for app" 
  task :get, [:name] => :environment do |t, args|
    a = AuthToken.find_by(name: args[:name])
    if a.nil?
      puts "Error: app: '#{args[:name]}' does not exist"
    else
      puts "token: #{a.token} for app: #{a.name}"
    end
  end
end
