User.create!(name:  "かずき",
             email: "example@railstutorial.org",
             password:              "password",
             password_confirmation: "password",
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
             book_id:1,
             number:1)

# リレーションシップ
users = User.all
user  = users.first
following = users[2..20]
followers = users[3..10]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }
