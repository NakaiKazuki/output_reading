FactoryBot.define do
  factory :book, class: 'Book' do
    title { 'Book title1' }
    created_at { 10.minutes.ago }
    association :user, factory: :user

    trait :add_image do
      image { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/images.jpg')) }
    end
  end

  factory :book2, class: 'Book' do
    title { 'Book title2' }
    created_at { 1.year.ago }
    association :user, factory: :user
  end

  factory :book3, class: 'Book' do
    title { 'Book title3' }
    created_at { 2.hours.ago }
    association :user, factory: :user
  end

  factory :book4, class: 'Book' do
    title { 'Book title4' }
    created_at { Time.zone.now }
    association :user, factory: :user
  end

  factory :other_book, class: 'Book' do
    title { 'Other User Book Title' }
    created_at { 3.years.ago }
    association :user, factory: :other_user

    trait :add_image do
      image { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/images.jpg')) }
    end
  end

  factory :books, class: 'Book' do
    sequence(:title) { |n| "Book title number-#{n}" }
    created_at { 5.years.ago }
    association :user, factory: :user
  end
end
