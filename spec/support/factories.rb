FactoryBot.define do
  factory :user do
    uniqname { Faker::Internet.username(specifier: 3..8) }
  end
  factory :loan do
    association :user, strategy: :build 
    id { Faker::Number.number(digits: 16) }
    title { Faker::Book.title }
    author { Faker::Book.author }
    mms_id { "99#{Faker::Number.number(digits: 12)}6000" }
    return_date { Faker::Date.backward(days: 365)}
    before(:create) do |loan| 
      returned = loan.return_date
      loan.checkout_date = Faker::Date.between(from: returned - 180.days, to: returned)
    end
  end
end
