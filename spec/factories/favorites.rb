FactoryBot.define do
  factory :favorite, class: Favorite do
    association :user, factory: :user
    association :book, factory: :book
  end
  factory :other_user_favorite, class: Favorite do
    association :user, factory: :other_user
    association :book, factory: :book
  end
end
