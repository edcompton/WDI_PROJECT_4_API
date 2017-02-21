load 'FileNavigator'
load './seeding/final/BalanceSheetScraper'
load './seeding/final/CashflowStatementScraper'
load './seeding/final/DocumentAndEntityinformatinScraper'
load './seeding/final/IncomeStatementScraper'

f1.bs_yearly_results << bs1
f1.is_yearly_results << is1
f1.cf_yearly_results << cf1
f1.dei_statement = dei1

c1.filings << f1

w1.companies << c1
