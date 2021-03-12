require 'sinatra'
require 'sinatra/json'

get "/almaws/v1/analytics/reports" do
  json JSON.parse(File.read('./circ_history.json'))
end
