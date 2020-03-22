FactoryBot.define do
  factory :zip_association do
    sequence(:zip) { |n| n }
    sequence(:cbsa, 100) { |n| n }
  end
end
