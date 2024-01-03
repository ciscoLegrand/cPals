FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password { 'password123' }
    password_confirmation { 'password123' }
    name { Faker::Name.first_name }
    surname { Faker::Name.last_name }
    username { Faker::Internet.unique.username(specifier: 10..50) }
    role { :user }
    phone { Faker::PhoneNumber.phone_number }
  end
end
