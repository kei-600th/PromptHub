FactoryBot.define do
  factory :sample do
    sequence(:title) { |n| "TEST_SAMPLE#{n}"}
    sequence(:description) { "このサンプルは最高です。改行しました"}
  end
end