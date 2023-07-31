FactoryBot.define do
  factory :prompt do
    sequence(:request_text) { |n| "質問です。#{n}" }
    sequence(:response_text) { |n| "回答です。#{n}" }
    sample
  end
end
