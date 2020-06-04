User.create!(name:  "かずき",
             email: "example@railstutorial.org",
             password:              "hogehogehoge",
             password_confirmation: "hogehogehoge",
             admin: true,
             activated: true)


20.times do |n|
  name  = Faker::Japanese::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               admin: false,
               activated: true)
end

Book.create!(title: "テストタイトル",
             user_id:1,
             )

Chapter.create!(content: "テスト投稿",
             user_id:1,
             book_id:1)
