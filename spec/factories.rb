FactoryBot.define do
  factory :user do
    sequence :email do |n|
      "dummyEmail#{n}@gmail.com"
    end

    password { "sdRf#8gu5r@6n" }
    password_confirmation { "sdRf#8gu5r@6n" }
  end

  factory :gram do
  	message {"Hello!"}
  	picture { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'picture.png').to_s, 'image/png') }
  	
  	association :user
  end
end