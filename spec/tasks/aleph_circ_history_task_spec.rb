require 'rails_helper'
require 'csv'

describe "aleph_circ_history:load_history" do
  before(:each) do
    @file = Tempfile.new(['tempfile','.csv'],'/app/spec/fixtures')
  end

  after(:each) do
    Rake::Task["aleph_circ_history:load"].reenable
    @file.close
    @file.unlink
  end
  let(:user_emcard) { create(:user, uniqname: 'emcard', retain_history: true) }
  let(:load_circ_history){ ->(path){ Rake::Task["aleph_circ_history:load"].invoke(path) }}
  let(:circ_fixture){'./spec/fixtures/aleph_circ_hist_sample.tsv'}
  let(:get_history){ CSV.read(circ_fixture, headers: true, col_sep: "\t") }
  def write_temp(data)
    @file.write(data.to_csv)
    @file.rewind
  end

  it "loads users" do
    expect(User.count).to eq(0)
    load_circ_history.call(circ_fixture)
    expect(User.count).to eq(1)
    expect(User.first.uniqname).to eq('emcard')
    expect(User.first.retain_history).to eq(true)
  end
  it "adds appropriate loan data" do
    expect(Loan.count).to eq(0)
    load_circ_history.call(circ_fixture)
    expect(Loan.count).to eq(3)
  end

end
