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

c1 = Company.create({
  ticker: 'AAPL',
  name: 'Apple',
  sector: 'World Domination'
  })

f1 = Filing.create({
  accession_id: "000162828016020309"
})

bs1 = BsYearlyResult.create({
  cce: -345
  })

is1 = IsYearlyResult.create({
  sales: 2000
  })

cf1 = CfYearlyResult.create({
  net_income: 2345
  })

dei1 = DeiStatement.create({
  year: 2016
  })

f1.bs_yearly_results << bs1
f1.is_yearly_results << is1
f1.cf_yearly_results << cf1
f1.dei_statement = dei1

c1.filings << f1

w1.companies << c1
