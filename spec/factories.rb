FactoryBot.define do
  factory :user do
    sequence :email do |n|
      "dummyEmail#{n}@gmail.com"
    end

    password { "sdRf#8gu5r@6n" }
    password_confirmation { "sdRf#8gu5r@6n" }
  end

  factory :gram do
  	message {"hello!"}
  	association :user
  end
end