require "rails_helper"
describe "get /v1/users/:uniqname/loans" do
  it "shows a patron's loan history" do
    loan = create(:loan)
    get "/v1/users/#{loan.user_uniqname}/loans"
    expect(response).to have_http_status(:success)
    expect(response.body).to include(loan.title)
  end
end
describe "get /v1/users/:uniqname/loans/download" do
  context "csv" do
    it "returns a patrons full history as a csv download" do
      loan = create(:loan)
      get "/v1/users/#{loan.user_uniqname}/loans/download.csv"
      expect(response.body).to include("mms_id")
      expect(response.body).to include(loan.mms_id)
      expect(response.headers["Content-Type"]).to eq("text/csv")
      expect(response.headers["Content-Disposition"]).to include("filename=\"#{loan.user_uniqname}_circ_history_#{Date.today}.csv\"")
    end
  end
end
describe "get /v1/users/:uniqname" do
  it "handle patron with email address uniqname" do
    user = create(:user, uniqname: 'so.and.so@example.com')
    get "/v1/users/#{CGI.escape(user.uniqname)}"
    expect(response).to have_http_status(:success)
  end
  it "shows a patron's loan retention status and confirmation status" do
    user = create(:user)
    get "/v1/users/#{user.uniqname}"
    expect(response).to have_http_status(:success)
    expect(response.body).to include('retain_history')
    expect(response.body).to include('confirmed')
    expect(response.body).to include(user.uniqname)
  end
end
describe "put /v1/users/:uniqname {retain_history: false}" do
  it "changes a patron's loan retention status and confirmation status and deletes existing loans; returns updated user" do
    user = create(:user, retain_history: true, confirmed: false)
    loan = create(:loan, user: user)
    put "/v1/users/#{user.uniqname}", params: {:retain_history => false }
    expect(response).to redirect_to("/v1/users/#{user.uniqname}")
    updated_user = User.first 
    expect(updated_user.retain_history).to be_falsey
    expect(updated_user.confirmed).to be_truthy
    expect(Loan.all.count).to eq(0)
  end
end
