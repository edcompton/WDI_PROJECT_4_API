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

##Saturday 18 February

12:00 - standup, trello todo list will be made. me and jack and ed continuing work on scraping.  Henry doing wire frames.

until 14:15 - worked on making parent and child classes for parsers and scrapers.  refactors my code into a class with modular functions all triggered by an initialize. takes a file path spits out hash.

17:00 - angualr authetication

##Sunday 19 February

10:45 - back to scraping

- henry's house
- worked all day on scraping
- starting point: v1 for cash flow and balance sheet.  Our methods were printing differently formatted descriptive hashes with a key value pair for each cell including out title, row title, onclick phrase and value.
- lead to discussion on what format we should both aim for, decided to try and output a hash which could eventually be passed as an argument to .create().  This meant we had to discuss (without consultation from henry and ed, felt good to be able to do so knowing they trust us to executive choices within the remit of out delegated task) the layout of our eventual database table / tables. worked out that a comp as many filings, filings have one balance sheet and balance sheets have many yearly results.  With the hash format decided we both reworked our methods before meeting again to take the best code and learnings from each method.
- after the above was achieved we sat down to refactor our code into parent class and child classes for each document type. Moving as many of our small, generic methods into the parent class as possible.  Big break through was hash creating method and using column indexes.
```  
def create_yearly_results_hash date, column_index
    {
      IS_id: 1,
      year: get_year_integer(date),
      date: date,
      UNITS: get_units,
      SALES: get_cell_float("SALES", column_index),
      COGS: get_cell_float("COGS", column_index),
      EBIT: get_cell_float("EBIT", column_index),
      PBT: get_cell_float("PBT", column_index),
      TAX: get_cell_float("TAX", column_index),
      NET_INCOME: get_cell_float("NET_INCOME", column_index),
      BASIC_EPS: get_cell_float("BASIC_EPS", column_index),
      DILUTED_EPS: get_cell_float("DILUTED_EPS", column_index)
    }
  end
```
- were were both really impressed with how modular out code was, we moved a lot of code around with almost no issues.
- slight differences in some of our codes and xpath queries meant we could build our code to deal with multiple eventualities.
- string concatination was difficult, nested quotes in onlick attribute, xpath doesn't like it, used contains but with underscore and closing single quote
- negative numbers was a learning point
- also had accidentialy built in error handling: if no object id found with the xpath query when populating the data hash then the array of onlcick phrase s which have been tried are pushed into the final data hash.  This is helpful for finding edge cases. Can return nil instead but we will leave in to help improve out code.
- really productive data, really easy to adapt method to other document types and other companies.  Code feels very stable due the small simple methods that we have used. very east to debug.

##Monday

10:00-11:00 - standup, made a to do list, mostly on the board (henry has pics) end goal of today (At a push) is to be spitting out json from out api for 4 companies. Also went into details on our models (erd on board), really good for the team all being on the same page.

11:00-11:40 - dev diary update and trello board update.
