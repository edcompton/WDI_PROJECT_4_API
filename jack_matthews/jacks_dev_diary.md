#Development Diary

##Thursday 16 February 2017
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

22:53 - using xpath to identify correct row/link on value then traversing dom to collect all desired information.  Xpath objects are great to loop though.  getting some good output now.

##Friday 17 February

10:30 - stand up, ed up to speed, delegating work (ed saving htmls, jm and jk parsing htmls, henry working on out financial models and database table fields)

lunch

13:30 - parsed html dock into properly formatted ruby hash

16:15 - team meeting, discussed how to make sure we capture the rows and values that we require for out model as have currently hard coded the on_click titles for apple into an array which is looped through.
Also discussed testing and the above hash structure - what should be saved, discarded rows and empty model rows.
Ed showed his html scraping progress.
Alex suggested we store the array of possible row titles that we will need to be looking for in a yml file.  our passing methods should be generic and stored in a class and reference the yml file.
Agreed to dry dev diary and dry code before end of today so we can present to each other tomorrow morning.
