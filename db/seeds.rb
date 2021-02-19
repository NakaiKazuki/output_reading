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

30.times do |n|
  title  = Faker::Book.title
  random_id = rand(1..20)
  Book.create!(title: title,
    user_id: random_id,
  )
end

# リレーションシップ
users = User.all
user  = users.first
following = users[2..20]
followers = users[3..10]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }
