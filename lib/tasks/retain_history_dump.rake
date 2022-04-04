desc "dump retain history status"
task dump_retain_history: :environment do
  puts User.first.attributes.keys.to_csv
  puts User.all.map { |x| x.attributes.keys.map { |y| x[y] }.to_csv }
end
