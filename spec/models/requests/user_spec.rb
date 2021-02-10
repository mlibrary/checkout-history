require "rails_helper"
describe "get /v1/user/:uniqname/loans" do
  it "shows a patron's loan history" do
    loan = create(:loan)
    byebug
    expect(Loan.first.title).to eq(loan.title)
  end
end
