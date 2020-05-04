FactoryBot.define do

  factory :user do
    name{"Example User"}
    email{"user@example.com"}
    password{"password"}
    password_confirmation{"password"}
  end

  factory :other_user, class: User do
    name { "Sterling Archer" }
    email { "duchess@example.gov" }
    password { "foobar" }
    password_confirmation { "foobar" }
  end
end
