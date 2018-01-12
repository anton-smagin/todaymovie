FactoryBot.define do
  factory :show do
    price { Faker::Number.number(3) }
    time { Faker::Time.between(Time.now, Time.now + 1.day) }
    association :movie
    association :theatre
  end
end
