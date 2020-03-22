FactoryBot.define do
  factory :mdiv_cbsa_association do
    sequence(:cbsa) { |n| n }
    sequence(:mdiv, 100) { |n| n }
  end
end
