# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

u1 = User.create({
  first_name: 'Jack',
  last_name: 'Matthews',
  email: 'jackhkmatthews@gmail.com',
  password: 'password',
  password_confirmation: 'password'
  })

w1 = Watchlist.create({
  user_id: u1.id
  })

c1 = {
  ticker: 'AAPL',
  name: 'Apple',
  sector: 'World Domination'
  }

w1.companies.create(c1)
