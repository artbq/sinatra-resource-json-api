FactoryGirl.define do

  factory :user do
    name { Faker::Name.name }
    age { rand(101) + 18 }
  end
end

