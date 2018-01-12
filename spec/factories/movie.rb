FactoryBot.define do
  factory :movie do
    title { Faker::App.name }
    link { Faker::Internet.url }
    has_shows { Faker::Boolean.boolean }

    trait :fixture do
      title 'Затерянный город Z'
      has_shows false
    end
  end
end
