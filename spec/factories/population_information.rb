FactoryBot.define do
  factory :population_information do
    sequence(:cbsa) { |n| n }
    sequence(:name) { |n| "NAME_#{n}" }
    lsad { 'Metropolitan Statistical Area' }
    pop_2010 { 2010 }
    pop_2011 { 2011 }
    pop_2012 { 2012 }
    pop_2013 { 2013 }
    pop_2014 { 2014 }
    pop_2015 { 2015 }
  end
end
