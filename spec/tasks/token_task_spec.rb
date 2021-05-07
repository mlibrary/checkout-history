require 'rails_helper'
describe "token:generate" do
  after(:each) do
    Rake::Task["token:generate"].reenable
  end
  subject do
    Rake::Task["token:generate"].invoke('app_name')
  end
  it "creates a new token" do
    expect(AuthToken.all.count).to eq(0)
    subject
    expect(AuthToken.all.count).to eq(1)
  end
  it "displays the new token" do
    expect{subject}.to  output(/token: [[:alnum:]]{36} for app: app_name/).to_stdout
  end
  it "has name that's given as parameter" do
    subject
    expect(AuthToken.first.name).to eq('app_name')
  end
  it "prints error if unable to save" do
    create(:auth_token, name: 'app_name')
    expect{subject}.to output("Errors: Name has already been taken\n").to_stdout
  end
end
describe "token:regenerate" do
  after(:each) do
    Rake::Task["token:regenerate"].reenable
  end
  before(:each) do
    create(:auth_token, name: 'app_name')
  end
  subject do
    Rake::Task["token:regenerate"].invoke('app_name')
  end
  it "creates a new token" do
    old_token = AuthToken.first.token
    subject
    expect(AuthToken.first.token).not_to eq(old_token)
  end
  it "displays a token" do
    expect{subject}.to  output(/token: [[:alnum:]]{36} for app: app_name/).to_stdout
  end
  it "does not display the old token" do
    old_token = AuthToken.first.token
    expect{subject}.not_to  output("token: #{old_token} for app: app_name").to_stdout
  end
  it "has name that's given as parameter" do
    subject
    expect(AuthToken.first.name).to eq('app_name')
  end
  it "prints error if app name doesn't exist" do
    expect{Rake::Task["token:regenerate"].invoke('non_existent_app')}.to output("Error: app: 'non_existent_app' does not exist\n").to_stdout
  end
end
describe "token:get" do
  after(:each) do
    Rake::Task["token:get"].reenable
  end
  subject do
    Rake::Task["token:get"].invoke('app_name')
  end
  it "prints token if token app exists" do
    create(:auth_token, name: 'app_name')
    expect{subject}.to  output(/token: [[:alnum:]]{36} for app: app_name/).to_stdout
  end
  it "prints error if app doesn't exist"  do
    expect{subject}.to output("Error: app: 'app_name' does not exist\n").to_stdout
  end
end
