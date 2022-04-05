require "rails_helper"

describe "alma_circ_history:load_history" do
  before(:each) do
    stub_request(:post, ENV["SLACK_URL"])
    stub_request(:get, ENV["PUSHMON_URL"])
    @stub = stub_alma_get_request(url: "analytics/reports",
      query: {path: ENV.fetch("CIRC_REPORT_PATH"), col_names: true, limit: 1000},
      body: File.read("./spec/fixtures/circ_history.json"))
  end
  after(:each) do
    Rake::Task["alma_circ_history:load"].reenable
  end

  let(:user_ajones) { create(:user, uniqname: "ajones", retain_history: true) }
  let(:user_emcard) { create(:user, uniqname: "emcard", retain_history: true) }
  let(:load_circ_history) { Rake::Task["alma_circ_history:load"].invoke }

  it "calls alma for latest circ history report" do
    load_circ_history
    expect(@stub).to have_been_requested.times(1)
  end
  it "logs an error if it can't load the report" do
    @stub.to_return(body: File.read("./spec/fixtures/alma_error.json"), status: 500, headers: {content_type: "application/json"})
    @stub.response # clear out original response
    expect(Rails.logger).to receive(:error).with("Alma Report Failed to Load")
    load_circ_history
  end
  it "loads new circ history into the db and downcases uniqnames" do
    user_ajones
    user_emcard
    expect(Loan.all.count).to eq(0)
    load_circ_history
    expect(Loan.all.count).to eq(2)
  end
  it "skips over already loaded history" do
    user_ajones
    user_emcard
    loan = create(:loan, id: "3159980960006381", title: "my_title")
    expect(Loan.all.count).to eq(1)
    load_circ_history
    expect(Loan.all.count).to eq(2)
    expect(Loan.find(loan.id).title).to eq("my_title")
  end

  it "it adds user if they don't exist" do
    user_ajones
    load_circ_history
    expect(User.all.count).to eq(2)
  end
  it "does not save data for new user" do
    user_ajones
    load_circ_history
    expect(Loan.all.count).to eq(1)
  end
  it "skips over users who have opted-out" do
    user_ajones.update(retain_history: false)
    user_emcard
    load_circ_history
    expect(User.all.count).to eq(2)
    expect(Loan.all.count).to eq(1)
  end
  it "handles giant title" do
    user_ajones
    user_emcard
    loans = File.read("./spec/fixtures/circ_history.json")
    super_long_title = "a" * 1000
    loans.gsub!("Between the world and me", super_long_title)
    @stub.to_return(body: loans, headers: {content_type: "application/json"})
    @stub.response # clear out original response
    load_circ_history
    expect(Loan.all.count).to eq(2)
  end
  it "handles giant author" do
    user_ajones
    user_emcard
    loans = File.read("./spec/fixtures/circ_history.json")
    super_long_author = "a" * 1000
    loans.gsub!("Caldwell, John, 1938-", super_long_author)
    @stub.to_return(body: loans, headers: {content_type: "application/json"})
    @stub.response # clear out original response
    load_circ_history
    expect(Loan.all.count).to eq(2)
  end
  it "handles nil author" do
    user_ajones
    user_emcard
    loans = File.read("./spec/fixtures/circ_history.json")
    loans.gsub!('<Column1>Caldwell, John, 1938-</Column1>\n', "")
    @stub.to_return(body: loans, headers: {content_type: "application/json"})
    @stub.response # clear out original response
    load_circ_history
    expect(Loan.all.count).to eq(2)
  end
  it "handles nil title" do
    user_ajones
    user_emcard
    loans = File.read("./spec/fixtures/circ_history.json")
    loans.gsub!('<Column3>Between the world and me /</Column3>\n', "")
    @stub.to_return(body: loans, headers: {content_type: "application/json"})
    @stub.response # clear out original response
    load_circ_history
    expect(Loan.all.count).to eq(2)
  end
end
describe "alma_circ_history:purge" do
  before(:each) do
    @stub = stub_alma_get_request(url: "analytics/reports",
      query: {path: ENV.fetch("PATRON_REPORT_PATH"), col_names: true, limit: 1000},
      body: File.read("./spec/fixtures/non_expired_patrons.json"))
  end
  after(:each) do
    Rake::Task["alma_circ_history:purge"].reenable
  end
  let(:user_ajones) { create(:user, uniqname: "ajones", retain_history: true) }
  let(:user_emcard) { create(:user, uniqname: "emcard", retain_history: true) }
  let(:purge_users) { Rake::Task["alma_circ_history:purge"].invoke }
  it "purges users not in the report" do
    emcard = user_emcard
    ajones = user_ajones
    create(:loan, user: emcard)
    create(:loan, user: ajones)
    expect(Loan.count).to eq(2)
    expect(User.count).to eq(2)
    purge_users # Report only has user with uniqname: 'EMCARD'
    expect(Loan.count).to eq(1)
    expect(Loan.first.user_uniqname).to eq("emcard")
    expect(User.first.uniqname).to eq("emcard")
  end
  it "logs an error if it can't load the report" do
    @stub.to_return(body: File.read("./spec/fixtures/alma_error.json"), status: 500, headers: {content_type: "application/json"})
    @stub.response # clear out original response
    expect(Rails.logger).to receive(:error).with("Alma Report Failed to Load")
    purge_users
  end
end
