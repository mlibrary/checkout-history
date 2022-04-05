require "securerandom"
namespace :token do
  desc "generates a new token with associated name"
  task :generate, [:name] => :environment do |t, args|
    a = AuthToken.new(name: args[:name])
    if a.save
      puts "token: #{a.token} for app: #{a.name}"
    else
      puts "Errors: #{a.errors.full_messages.join("; ")}"
    end
  end
  desc "regenerates token for app name"
  task :regenerate, [:name] => :environment do |t, args|
    a = AuthToken.find_by(name: args[:name])
    if a.nil?
      puts "Error: app: '#{args[:name]}' does not exist"
    elsif a.regenerate_token
      puts "token: #{a.token} for app: #{a.name}"
    else
      puts "Errors: #{a.errors.full_messages.join("; ")}"
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
