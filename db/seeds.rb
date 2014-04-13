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
  email: "paulgrant@funrevision.com",
  password: DEFAULT_INSECURE_PASSWORD,
  password_confirmation: DEFAULT_INSECURE_PASSWORD,
  admin: true
})

User.create({
  first_name: "Danielle",
  last_name: "Porter",
  profile_name: "DJ_Danny_xo",
  email: "danielleporter@funrevision.com",
  password: DEFAULT_INSECURE_PASSWORD,
  password_confirmation: DEFAULT_INSECURE_PASSWORD
})

User.create({
  first_name: "Christopher",
  last_name: "Jones",
  profile_name: "Christopher_Jones",
  email: "christopherjones@funrevision.com",
  password: DEFAULT_INSECURE_PASSWORD,
  password_confirmation: DEFAULT_INSECURE_PASSWORD
})

User.create({
  first_name: "Rebecca",
  last_name: "Bailey",
  profile_name: "BeccyBoo",
  email: "rebeccabailey@funrevision.com",
  password: DEFAULT_INSECURE_PASSWORD,
  password_confirmation: DEFAULT_INSECURE_PASSWORD
})

User.create({
  first_name: "Sam",
  last_name: "Morris",
  profile_name: "SamMorris",
  email: "jooodif@funrevision.com",
  password: DEFAULT_INSECURE_PASSWORD,
  password_confirmation: DEFAULT_INSECURE_PASSWORD
})

User.create({
  first_name: "Pulgoy",
  last_name: "Rovnitov",
  profile_name: "PulgoyFromSpace",
  email: "pulgoyrovnitov@funrevision.com",
  password: DEFAULT_INSECURE_PASSWORD,
  password_confirmation: DEFAULT_INSECURE_PASSWORD
})

u1  = User.find_by_email('itspaulgrant@gmail.com')
u2 = User.find_by_email('lcj02@stran.ac.uk')
u3  = User.find_by_email('rach.s.g@hotmail.com')
u4 = User.find_by_email('jonny.goudy@hotmail.com')
u5  = User.find_by_email('jooodif@yahoo.com')
u6  = User.find_by_email('gregoryalexanderfox@gmail.com')

u1.statuses.create(content: "Hello, world!")
u2.statuses.create(content: "Hi, I'm Danielle")
u3.statuses.create(content: "Hello from the internet!")
u4.statuses.create(content: "I want to learn maths!")
u5.statuses.create(content: "This site is awesome!")
u6.statuses.create(content: "Hello, is it me you're looking for?")

UserFriendship.request(u1, u2).accept!
UserFriendship.request(u5, u1)
UserFriendship.request(u6, u1)