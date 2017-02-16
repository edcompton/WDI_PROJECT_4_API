#Development Diary

##Friday 16 February 2017
16:00 - broad chat about the urls we will be scraping, accession id's, company tickers, the documents we will be scraping (3 docs per accession/filling).
What we will be taking from each statement (income, cashflow and the other), what different companies call the different fields on their statements.
- began discussing the above with regards to SQL tables, queries and active record:
    company has many accessions, accessions have one income statement, one cashflow and one other statement.

18:00 - git master admin and team git guide.

18:22 - (jm and jf) started looking at JF and HD's previous work on nokogiri. aiming to successfully scape one income statement for appl and parse the fields we want into a ruby hash.

18:42 - familiarising myself with the sec document website and the urls we will be scraping.

19:39 - xpath vs css selectors, following Nokogiri guide

20:24 - looping though manages to print out first three rows of apples IS (nokogiri, xpath, .each_with_index)

<img width="850" alt="screen shot 2017-02-16 at 20 30 40" src="https://cloud.githubusercontent.com/assets/20629455/23039963/72768190-f487-11e6-8e98-297123928f27.png">

22:00 - another play
