FactoryBot.define do
  factory :user do
    uniqname { Faker::Internet.username(specifier: 3..8, separators: []) }
  end
  factory :loan do
    association :user, strategy: :build 
    id { Faker::Number.number(digits: 16) }
    title { Faker::Book.title }
    author { Faker::Book.author }
    mms_id { "99#{Faker::Number.number(digits: 12)}6000" }
    before(:create) do |loan| 
      if loan.checkout_date.nil?
        loan.return_date = Faker::Date.backward(days: 365)
        loan.checkout_date = Faker::Date.between(from: loan.return_date - 180.days, 
                                                 to: loan.return_date)
      else
        loan.return_date = Faker::Date.between(from: loan.checkout_date, to: DateTime.now)
      end

    end
  end
end
