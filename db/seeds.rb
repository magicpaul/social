DEFAULT_INSECURE_PASSWORD = 'password1'

User.create({
  first_name: "Paul",
  last_name: "Grant",
  profile_name: "admin",
  email: "admin@funrevision.com",
  password: DEFAULT_INSECURE_PASSWORD,
  password_confirmation: DEFAULT_INSECURE_PASSWORD,
  admin: true
})

User.create({
  first_name: "Diane",
  last_name: "Porter",
  profile_name: "DJ_Diane",
  email: "user1@funrevision.com",
  password: DEFAULT_INSECURE_PASSWORD,
  password_confirmation: DEFAULT_INSECURE_PASSWORD
})

User.create({
  first_name: "Chris",
  last_name: "Jones",
  profile_name: "Christopher_Jones",
  email: "user2@funrevision.com",
  password: DEFAULT_INSECURE_PASSWORD,
  password_confirmation: DEFAULT_INSECURE_PASSWORD
})

User.create({
  first_name: "Sarah",
  last_name: "Bailey",
  profile_name: "SarahBoo",
  email: "user3@funrevision.com",
  password: DEFAULT_INSECURE_PASSWORD,
  password_confirmation: DEFAULT_INSECURE_PASSWORD
})

User.create({
  first_name: "Sam",
  last_name: "Morris",
  profile_name: "SamMorris",
  email: "user4@funrevision.com",
  password: DEFAULT_INSECURE_PASSWORD,
  password_confirmation: DEFAULT_INSECURE_PASSWORD
})

User.create({
  first_name: "Pulgo",
  last_name: "Rovv",
  profile_name: "PulgoFromSpace",
  email: "user5@funrevision.com",
  password: DEFAULT_INSECURE_PASSWORD,
  password_confirmation: DEFAULT_INSECURE_PASSWORD
})

u1 = User.find_by_email('admin@funrevision.com')
u2 = User.find_by_email('user1@funrevision.com')
u3 = User.find_by_email('user2@funrevision.com')
u4 = User.find_by_email('user3@funrevision.com')
u5 = User.find_by_email('user4@funrevision.com')
u6 = User.find_by_email('user5@funrevision.com')

u1.statuses.create(content: "Hello, world!")
u2.statuses.create(content: "Hi, I'm Diane")
u3.statuses.create(content: "Hello from the internet!")
u4.statuses.create(content: "I want to learn maths!")
u5.statuses.create(content: "This site is awesome!")
u6.statuses.create(content: "Hello, is it me you're looking for?")

UserFriendship.request(u1, u2).accept!
UserFriendship.request(u3, u4).accept!
UserFriendship.request(u3, u2).accept!
UserFriendship.request(u5, u2).accept!
UserFriendship.request(u4, u6).accept!
UserFriendship.request(u5, u1)
UserFriendship.request(u6, u1)