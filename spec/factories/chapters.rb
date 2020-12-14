FactoryBot.define do
  factory :chapter, class: 'Chapter' do
    content { 'Chapter Contet-1' }
    number { 1 }
    created_at { 4.hours.ago }
    association :user, factory: :user
    association :book, factory: :book

    trait :add_image do
      image { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/images.jpg')) }
    end
  end

  factory :other_book_chapter, class: 'Chapter' do
    content { 'Other Book Chapter Contet' }
    number { 3 }
    created_at { 5.hours.ago }
    association :user, factory: :user
    association :book, factory: :book2
  end

  factory :other_user_chapter, class: 'Chapter' do
    content { 'Other User Book Chapter Contet' }
    number { 4 }
    created_at { 5.hours.ago }
    association :user, factory: :other_user
    association :book, factory: :other_book
  end

  factory :chapters, class: 'Chapter' do
    sequence(:content) { |n| "Chapter Content number-#{n}" }
    sequence(:number) { |n| 1 + n }
    created_at { 5.years.ago }
    association :user, factory: :user
    association :book, factory: :book
  end
end
