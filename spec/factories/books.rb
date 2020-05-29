FactoryBot.define do
  factory :book,class: Book do
    trait :book_1 do
      title { "Book title1" }
      created_at { 10.minutes.ago }
    end

    trait :book_2 do
      title { "Book title2" }
      created_at { 3.years.ago }
    end

    trait :book_3 do
      title { "Book title3"  }
      created_at { 2.hours.ago }
    end

    trait :book_4 do
      title { "Book title4" }
      created_at { Time.zone.now }
    end
    association :user, factory: :user
  end

  factory :books,class: Book do
    sequence(:title){|n| "Book title number-#{n}"}
    association :user, factory: :user
  end
end
