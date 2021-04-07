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
  context ".find_or_create_by_uniqname" do
    it "downcases uniqname" do
      user = User.find_or_create_by_uniqname('SOANDSO')
      expect(user.uniqname).to eq('soandso')
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
      #from false to true; not something that should happen. 
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
end
