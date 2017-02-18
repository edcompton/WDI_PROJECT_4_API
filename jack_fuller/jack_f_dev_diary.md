#Development Diary

#Friday 16 February 2017

##Goals
To test various scraping tools and approaches to get and parse the relevant data from a single companies' SEC page. 

##Tasks
<ul>
<li>Researched various scraping tools including nokogiri and crack. Reading articles, forums, decided nokogiri was the way to go becauase fo speed + docs.</li>
<li>Did some test nokogiri scrapes on the raw xmls pulled from the sec website, worked out how to use xpath selectors </li>
<li>Though about structuring the scraper, decided on using a Class which would take a file ready to pass as an initialise argument.</li>
</ul>


##Research

http://ruby.bastardsbook.com/chapters/web-scraping/

#Saturday 17th February 2017
##Goals
Finish the scrapers for cash flow, balance sheet and