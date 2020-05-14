User.create!(name:  "Kazuki",
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
