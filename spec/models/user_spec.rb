require 'rails_helper'

RSpec.describe User, type: :model do
  context "#loans_page(limit:, offset:)" do
    before(:each) do
      @user = create(:user, retain_history: true)
      @loans = []
      (1..5).each do
        @loans.push(create(:loan, user: @user))
      end
    end
    it "returns the correct number of items" do
      expect(@user.loans_page(limit: 2, offset: 0).count).to eq(2)
    end
  end
  context "after setting retain history" do
    it "to false purges items from the history" do
      user = create(:user, retain_history: true)
      loans = []
      (1..5).each do
        loans.push(create(:loan, user: user))
      end
      expect(User.first.loans.count).to eq(5)
      user.update(retain_history: false)
      expect(User.first.loans.count).to eq(0)
    end
    it "to true it does not purge items from the history" do
      #example of migrated patron with circ history and default to false retain_history
      user = create(:user, retain_history: false) 
      loans = []
      (1..5).each do
        loans.push(create(:loan, user: user))
      end
      expect(User.first.loans.count).to eq(5)
      user.update(retain_history: true)
      expect(User.first.loans.count).to eq(5)
    end
  end
  context "after afirming the confirmation status" do
    it "sets active to true when confirmed is set to true" do
      user = create(:user, active: false, confirmed: false)
      user.update(confirmed: true)
      expect(User.first.active).to eq(true)
    end
  end
end
