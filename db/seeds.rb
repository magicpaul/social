# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
DEFAULT_INSECURE_PASSWORD = 'password1'

User.create({
  first_name: "Paul",
  last_name: "Grant",
  profile_name: "magicpaul",
  email: "itspaulgrant@gmail.com",
  password: DEFAULT_INSECURE_PASSWORD,
  password_confirmation: DEFAULT_INSECURE_PASSWORD
})

User.create({
  first_name: "Laura",
  last_name: "Grant",
  profile_name: "lcj02",
  email: "lcj02@stran.ac.uk",
  password: DEFAULT_INSECURE_PASSWORD,
  password_confirmation: DEFAULT_INSECURE_PASSWORD
})

User.create({
  first_name: "Rach",
  last_name: "Goudy",
  profile_name: "rachg",
  email: "rach.s.g@hotmail.com",
  password: DEFAULT_INSECURE_PASSWORD,
  password_confirmation: DEFAULT_INSECURE_PASSWORD
})

User.create({
  first_name: "Jonny",
  last_name: "Goudy",
  profile_name: "jonnyg",
  email: "jonny.goudy@hotmail.com",
  password: DEFAULT_INSECURE_PASSWORD,
  password_confirmation: DEFAULT_INSECURE_PASSWORD
})

User.create({
  first_name: "Jude",
  last_name: "Fox",
  profile_name: "jooodif",
  email: "jooodif@yahoo.com",
  password: DEFAULT_INSECURE_PASSWORD,
  password_confirmation: DEFAULT_INSECURE_PASSWORD
})

User.create({
  first_name: "Greg",
  last_name: "Fox",
  profile_name: "foxygreg",
  email: "gregoryalexanderfox@gmail.com",
  password: DEFAULT_INSECURE_PASSWORD,
  password_confirmation: DEFAULT_INSECURE_PASSWORD
})

paul  = User.find_by_email('itspaulgrant@gmail.com')
laura = User.find_by_email('lcj02@stran.ac.uk')
rach  = User.find_by_email('rach.s.g@hotmail.com')
jonny = User.find_by_email('jonny.goudy@hotmail.com')
jude  = User.find_by_email('jooodif@yahoo.com')
greg  = User.find_by_email('gregoryalexanderfox@gmail.com')


seed_user = paul

seed_user.statuses.create(content: "Hello, world!")
laura.statuses.create(content: "Hi, I'm Laura")
rach.statuses.create(content: "Hello from the internet!")
jonny.statuses.create(content: "I want to learn html javapress")
jude.statuses.create(content: "This site is awesome!")
greg.statuses.create(content: "Hello, is it me you're looking for?")

UserFriendship.request(seed_user, laura).accept!
UserFriendship.request(seed_user, jude)
UserFriendship.request(greg, seed_user)