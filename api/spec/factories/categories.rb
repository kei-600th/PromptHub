FactoryBot.define do
  factory :category do
    sequence(:name) { |n| "TEST_CATEGORY#{n}" }
    sequence(:image) { "example.jpg" }
  end
end
