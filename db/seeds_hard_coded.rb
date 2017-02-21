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

bs1 = BsYearlyResult.create([{
  :year=>2016,
  :date=>"Jun. 30, 2016",
  :unit=>"$ in Millions",
  :cce=>7102.0,
  :marketable_securities=>6246.0,
  :inventory=>4716.0,
  :accounts_recievable=>4373.0,
  :total_current_assets=>33782.0,
  :ppe_net=>19385.0,
  :goodwill=>44350.0,
  :other_intangible_assets=>24527.0,
  :total_assets=>127136.0,
  :accounts_payable=>9325.0,
  :accrued_expenses=>7449.0,
  :total_current_liabilities=>30770.0,
  :long_term_debt=>18945.0,
  :total_liabilities=>69153.0,
  :retained_earnings=>87953.0,
  :accumulated_other_comprehensive_income=>-15907.0,
  :total_liabilities_and_equity=>127136.0},
 {:year=>2015,
  :date=>"Jun. 30, 2015",
  :unit=>"$ in Millions",
  :cce=>6836.0,
  :marketable_securities=>4767.0,
  :inventory=>4979.0,
  :accounts_recievable=>4568.0,
  :total_current_assets=>29646.0,
  :ppe_net=>19655.0,
  :goodwill=>44622.0,
  :other_intangible_assets=>25010.0,
  :total_assets=>129495.0,
  :accounts_payable=>8138.0,
  :accrued_expenses=>8091.0,
  :total_current_liabilities=>29790.0,
  :long_term_debt=>18327.0,
  :total_liabilities=>66445.0,
  :retained_earnings=>84807.0,
  :accumulated_other_comprehensive_income=>-12780.0,
  :total_liabilities_and_equity=>129495.0}])

is1 = IsYearlyResult.create([{
  :year=>2016,
  :date=>"Sep. 24, 2016",
  :unit=>"$ in Millions",
  :sales=>215639.0,
  :cogs=>131376.0,
  :ebit=>60024.0,
  :pbt=>61372.0,
  :tax=>15685.0,
  :net_income=>45687.0,
  :basic_eps=>8.35,
  :diluted_eps=>8.31},
 {:year=>2015,
  :date=>"Sep. 26, 2015",
  :unit=>"$ in Millions",
  :sales=>233715.0,
  :cogs=>140089.0,
  :ebit=>71230.0,
  :pbt=>72515.0,
  :tax=>19121.0,
  :net_income=>53394.0,
  :basic_eps=>9.28,
  :diluted_eps=>9.22},
 {:year=>2014,
  :date=>"Sep. 27, 2014",
  :unit=>"$ in Millions",
  :sales=>182795.0,
  :cogs=>112258.0,
  :ebit=>52503.0,
  :pbt=>53483.0,
  :tax=>13973.0,
  :net_income=>39510.0,
  :basic_eps=>6.49,
  :diluted_eps=>6.45}])

cf1 = CfYearlyResult.create([{
  :year=>2016,
  :date=>"Sep. 24, 2016",
  :unit=>"$ in Millions",
  :net_income=>45687.0,
  :d_and_a=>10505.0,
  :share_compensation=>4210.0,
  :deferred_tax=>4938.0,
  :inventories=>217.0,
  :receivables=>1095.0,
  :payables=>1791.0,
  :net_cash_from_operating_activities=>65824.0,
  :capex=>-12734.0,
  :purchases_of_marketable_securities=>-142428.0,
  :proceeds_from_sales_of_marketable_securities=>90536.0,
  :proceeds_from_maturities_of_marketable_securities=>21258.0,
  :acquisitions=>-297.0,
  :net_cash_used_in_investing_activities=>-45977.0,
  :issuance_of_stock=>495.0,
  :long_term_debt_raised=>24954.0,
  :long_term_debt_repayments=>-2500.0,
  :net_short_term_debt_issued=>-397.0,
  :payment_of_dividends=>-12150.0,
  :stock_repurchases=>-29722.0,
  :net_cash_from_financing_activities=>-20483.0,
  :net_change_in_cash=>-636.0},
 {:year=>2015,
  :date=>"Sep. 26, 2015",
  :unit=>"$ in Millions",
  :net_income=>53394.0,
  :d_and_a=>11257.0,
  :share_compensation=>3586.0,
  :deferred_tax=>1382.0,
  :inventories=>-238.0,
  :receivables=>611.0,
  :payables=>5400.0,
  :net_cash_from_operating_activities=>81266.0,
  :capex=>-11247.0,
  :purchases_of_marketable_securities=>-166402.0,
  :proceeds_from_sales_of_marketable_securities=>107447.0,
  :proceeds_from_maturities_of_marketable_securities=>14538.0,
  :acquisitions=>-343.0,
  :net_cash_used_in_investing_activities=>-56274.0,
  :issuance_of_stock=>543.0,
  :long_term_debt_raised=>27114.0,
  :long_term_debt_repayments=>0.0,
  :net_short_term_debt_issued=>2191.0,
  :payment_of_dividends=>-11561.0,
  :stock_repurchases=>-35253.0,
  :net_cash_from_financing_activities=>-17716.0,
  :net_change_in_cash=>7276.0},
 {:year=>2014,
  :date=>"Sep. 27, 2014",
  :unit=>"$ in Millions",
  :net_income=>39510.0,
  :d_and_a=>7946.0,
  :share_compensation=>2863.0,
  :deferred_tax=>2347.0,
  :inventories=>-76.0,
  :receivables=>-4232.0,
  :payables=>5938.0,
  :net_cash_from_operating_activities=>59713.0,
  :capex=>-9571.0,
  :purchases_of_marketable_securities=>-217128.0,
  :proceeds_from_sales_of_marketable_securities=>189301.0,
  :proceeds_from_maturities_of_marketable_securities=>18810.0,
  :acquisitions=>-3765.0,
  :net_cash_used_in_investing_activities=>-22579.0,
  :issuance_of_stock=>730.0,
  :long_term_debt_raised=>11960.0,
  :long_term_debt_repayments=>0.0,
  :net_short_term_debt_issued=>6306.0,
  :payment_of_dividends=>-11126.0,
  :stock_repurchases=>-45000.0,
  :net_cash_from_financing_activities=>-37549.0,
  :net_change_in_cash=>-415.0
  }])

dei1 = DeiStatement.create({
  :year=>2016,
  :share_units=>"",
  :monetary_units=>" $ in Millions",
  :document_type=>"10-K",
  :amendment_flag=>false,
  :document_period_end_date=>"Sep. 24,  2016  ",
  :document_fiscal_year_focus=>2016,
  :document_fiscal_period_focus=>"FY",
  :trading_symbol=>"AAPL",
  :entity_registrant_name=>"APPLE INC",
  :entity_central_index_key=>320193,
  :current_fiscal_year_end_date=>"09 24",
  :entity_well_known_seasoned_issuer=>true,
  :entity_current_reporting_status=>true,
  :entity_voluntary_filers=>false,
  :entity_filer_category=>"Large Accelerated Filer",
  :entity_common_stock_shares_outstanding=>5332313,
  :entity_public_float=>578807})

f1.bs_yearly_results << bs1
f1.is_yearly_results << is1
f1.cf_yearly_results << cf1
f1.dei_statement = dei1

c1.filings << f1

w1.companies << c1
