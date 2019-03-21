FactoryBot.define do
  factory :user do
    email                         { 'test@email.com' }
    password                      { 'test1234' }
    password_confirmation         { 'test1234' }
  end
end