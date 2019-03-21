FactoryBot.define do
  factory :search_result do
    album_name                    { 'Year of Hibernation' }
    release_date                  { '2018-03-15' }
    album_url                     { 'spotify.com/89h8h' }
    association :user
  end
end