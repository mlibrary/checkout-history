require "rails_helper"
describe "get /v1/users/:uniqname/loans" do
  it "shows a patron's loan history" do
    loan = create(:loan)
    get "/v1/users/#{loan.user_uniqname}/loans"
    expect(response).to have_http_status(:success)
    expect(response.body).to include(loan.title)
  end
end
