FactoryBot.define do

  factory :chapter,class: Chapter do
    content { "Chapter Contet-1" }
    created_at { 4.hours.ago }
    association :user, factory: :user
    association :book, factory: :book
    end

  factory :chapter_2,class: Chapter do
      content { "Chapter Contet-2" }
      created_at { 3.hours.ago }
      association :user, factory: :user
      association :book, factory: :book
    end

    factory :other_book_chapter,class: Chapter do
        content { "Other Book Chapter Contet" }
        created_at { 5.hours.ago }
        association :user, factory: :user
        association :book, factory: :book_2
    end

    factory :other_user_chapter,class: Chapter do
        content { "Other User Book Chapter Contet" }
        created_at { 5.hours.ago }
        association :user, factory: :other_user
        association :book, factory: :other_book
    end

    factory :chapters,class: Chapter do
      sequence(:content){|n| "Chapter Content number-#{n}"}
      created_at { 5.years.ago }
      association :user, factory: :user
      association :book, factory: :book
    end

end
