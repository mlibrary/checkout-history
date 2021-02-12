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
end
