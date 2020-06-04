FactoryBot.define do

  factory :book,class: Book do
    title { "Book title1" }
    created_at { 10.minutes.ago }
    association :user, factory: :user
    end

  factory :book_2,class: Book do
      title { "Book title2" }
      created_at { 1.years.ago }
      association :user, factory: :user
    end

  factory :book_3,class: Book do
      title { "Book title3"  }
      created_at { 2.hours.ago }
      association :user, factory: :user
    end

  factory :book_4,class: Book do
      title { "Book title4" }
      created_at { Time.zone.now }
      association :user, factory: :user
    end

  factory :user_book,class: Book do
    title { "User Book title" }
    created_at { 2.years.ago }
    association :user, factory: :user
  end

  factory :other_book,class: Book do
    title { "Other user Book title" }
    created_at { 3.years.ago }
    association :user, factory: :other_user
  end

  factory :books,class: Book do
    sequence(:title){|n| "Book title number-#{n}"}
    created_at { 5.years.ago }
    association :user, factory: :user
  end
end
