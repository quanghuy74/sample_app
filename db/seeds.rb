User.create!(name: "Example User",
             email: "huy25107@gmail.com",
             admin: true,
             password: "123123",
             password_confirmation: "123123",
             activated: true, activated_at: Time.zone.now)
# Generate a bunch of additional users.
30.times do |n|
  name = Faker::Name.name
  email = "example-#{n + 1}@railstutorial.org"
  password = "123123"
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password,
               activated: true, activated_at: Time.zone.now)
end
