FactoryBot.define do
  factory :posts,class: Post do
    trait :post_1 do
      content { "I just ate an orange!" }
      created_at { 10.minutes.ago }
    end

    trait :post_2 do
      content { "Check out the @tauday site by @mhartl: http://tauday.com" }
      created_at { 3.years.ago }
    end

    trait :post_3 do
      content { "Sad cats are sad: http://youtu.be/PKffm2uI4dk"  }
      created_at { 2.hours.ago }
    end

    trait :post_4 do
      content { "Writing a short test" }
      created_at { Time.zone.now }
    end
    association :user, factory: :user
  end
end
