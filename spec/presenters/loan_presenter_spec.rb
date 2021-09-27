require 'rails_helper'

RSpec.describe LoansPresenter do
  before(:each) do
    @user = create(:user, retain_history: true)
    @returned_most_recently = create(:loan, user: @user, checkout_date: Time.current - 5.days, return_date:  Time.current - 1.days)
    @returned_longest_ago = create(:loan, user: @user, checkout_date: Time.current - 5.days, return_date:  Time.current - 3.days)
  end
  it "can order by return_date least recent first" do 
    loans_presenter = LoansPresenter.new(user: @user, order_by: 'return_date').map{|x| x}
    expect(loans_presenter.first.return_date).to eq(@returned_longest_ago.return_date)
  end
  it "can order by return_date least recent first" do 
    loans_presenter = LoansPresenter.new(user: @user, order_by: 'return_date', direction: 'DESC').map{|x| x}
    expect(loans_presenter.first.return_date).to eq(@returned_most_recently.return_date)
  end
end
