FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "Test User #{n}" }
    sequence(:email) { |n| "test#{n}@example.com" }
    password { "password1" }
    password_confirmation { "password1" }
    activated { false }
    admin { false }
  end
end
