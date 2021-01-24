User.create!(name:  "管理者",
             email: "outputreading@example.com",
             password:              "password",
             password_confirmation: "password",
             admin: true,
             activated: true)

20.times do |n|
  name  = Faker::Japanese::Name.name
  email = "output-reading-#{n+1}@example.com"
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

Book.create!(title: "ゲストBook投稿",
             user_id:2,
             )

Chapter.create!(content: "テスト投稿",
                user_id:1,
                book_id:1,
                number:1)

Chapter.create!(content: "ゲストCahpter投稿",
                user_id:2,
                book_id:2,
                number:1)

# リレーションシップ
users = User.all
user  = users.first
following = users[2..20]
followers = users[3..10]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }
