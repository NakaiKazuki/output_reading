User.create!(name:  "Kazuki",
             email: "example@railstutorial.org",
             password:              "111111",
             password_confirmation: "111111")


20.times do |n|
  name  = Faker::Japanese::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password)
end
