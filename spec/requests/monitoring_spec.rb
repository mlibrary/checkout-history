require "rails_helper"
describe "get /-/live", type: :request do
  it "show OK" do
    get "/-/live"
    expect(response).to have_http_status(:success)
  end
end
