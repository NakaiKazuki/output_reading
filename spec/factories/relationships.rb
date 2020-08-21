FactoryBot.define do
  factory :relationship do
    association :follower, factory: :other_user
    association :followed, factory: :user
  end
end
