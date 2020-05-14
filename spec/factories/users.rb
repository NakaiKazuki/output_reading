FactoryBot.define do

  factory :user do
    name{"Example User"}
    email{"user@example.com"}
    password{"password"}
    password_confirmation{"password"}
    admin{true}
    activated { true }
  end

  factory :user_add_image, class: User do
    name{"Example User add image"}
    email{"user@example.com"}
    password{"password"}
    password_confirmation{"password"}
    admin{true}
    image{ Rack::Test::UploadedFile.new(File.join(Rails.root, "/spec/fixtures/images.jpg"))}
    activated { true }
  end

  factory :other_user, class: User do
    name { "Sterling Archer" }
    email { "duchess@example.gov" }
    password { "foobar" }
    password_confirmation { "foobar" }
    admin{ false }
    activated { true }
  end

  factory :no_activation_user, class: User do
    name { "No Activation" }
    email { "no@activation.co.jp" }
    password { "foobar" }
    password_confirmation { "foobar" }
    admin{ false }
    activated { false }
  end
#複数ユーザーの作成 _spec で let!(:users) { create_list(:users,15) }のように記述。15は作りたい個数

  factory :users, class:User do
    name{ "test" }
    sequence(:email){|n| "test#{n}@example.com"}
    password{"password"}
    password_confirmation{"password"}
    admin{false}
    activated { true }
  end

end
