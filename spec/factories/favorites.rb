FactoryBot.define do
  factory :favorite, class: 'Favorite' do
    association :user, factory: :user
    association :book, factory: :book
  end
end
