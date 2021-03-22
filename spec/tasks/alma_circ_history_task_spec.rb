require 'rails_helper'

describe "alma_circ_history:load_history" do
  before(:each) do
    @stub = stub_alma_get_request(url: 'analytics/reports', 
      query: {path: ENV.fetch('CIRC_REPORT_PATH'), col_names: true, limit: 1000}, 
      body: File.read('./spec/fixtures/circ_history.json') )
  end
  after(:each) do
    Rake::Task["alma_circ_history:load"].reenable
  end

  let(:user_ajones) { create(:user, uniqname: 'ajones', retain_history: true) }
  let(:user_emcard) { create(:user, uniqname: 'emcard', retain_history: true) }
  let(:load_circ_history){ Rake::Task["alma_circ_history:load"].invoke }

  it "calls alma for latest circ history report" do
    #load_circ_history
    Rake::Task["alma_circ_history:load"].invoke
    expect(@stub).to have_been_requested.times(1)
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
    loan = create(:loan, id: '3159980960006381', title: 'my_title')
    expect(Loan.all.count).to eq(1)
    load_circ_history
    expect(Loan.all.count).to eq(2)
    expect(Loan.find(loan.id).title).to eq('my_title')
  end

  it "it does not add a new user if a user doesn't exist" do
    user_ajones
    load_circ_history
    expect(Loan.all.count).to eq(1)
    expect(User.all.count).to eq(1)
  end
  it "skips over users who have opted-out" do
    user_ajones.update(retain_history: false)
    user_emcard
    load_circ_history
    expect(User.all.count).to eq(2)
    expect(Loan.all.count).to eq(1)
  end
  
end
