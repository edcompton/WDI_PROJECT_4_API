#Development Diary

##Friday 16 February 2017
16:00 - broad chat about the urls we will be scraping, accession id's, company tickers, the documents we will be scraping (3 docs per accession/filling).
What we will be taking from each statement (income, cashflow and the other), what different companies call the different fields on their statements.
- began discussing the above with regards to SQL tables, queries and active record:
    company has many accessions, accessions have one income statement, one cashflow and one other statement.

18:00 - git master admin and team git guide.

18:22 - (jm and jf) started looking at JF and HD's previous work on nokogiri. aiming to successfully scape one income statement for appl and parse the fields we want into a ruby hash.
