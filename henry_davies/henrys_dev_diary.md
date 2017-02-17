### Creating consistent financial models

Our first goal was building a financial model for each US listed company. 

Unfortunately, all companies report their financials in a different manner. Our first challenge was to come up with a model income statement, balance sheet and cash flow statement that is relevant for every single US company.

To do this, I started by taking four large companies: Apple, Coke, P&G, and Alphabet (Google). 

First, I looked into the HTML of the four companies' statements. I noticed that while there is huge discrepancy in the names of each line item, there is far less discrepancy in the official SEC reference for each line - which can be found in an onclick function of each field in the financial tables. For example, the four companies gave three different names for tax paid in the income statement, whereas the SEC reference was "defref_us-gaap_IncomeTaxExpenseBenefit" for all four. 

Next, I manually entered their financial statements - including both the name and reference - into an excel spreadsheet. My goal was to line them up as much as possible in order to work out what model would work for all four companies. 

To illustrate the process, below is picture of how the four companies reported their income statements. While I lined them up as much as possible, clear differences remained.

<XXXX PICTURE XXXX>

Despite this, there were enough similarities to come up with a basic model. US regulations state that each company has to report its sales, COGS, EBIT, PBT, tax and net income. This is enough for a bare-bones income statement: 

Sales
COGS
Gross profit = Sales - COGS
Opex = Gross profit - EBIT
EBIT
Finance and other expense = EBIT - PBT
PBT
Tax
Other adjustments = net PBT - tax - net income
Net income

From here, we could use conditional logic to show the breakdown of opex, finance & other expense, and other adjustments - if provided. For example, breaking opex down into the usual cost fields of selling & marketing, research & development, and general & adminstrative. 

The logic for the balance sheet and cash flow statement was similar. Compared to the income statement, there were more differences. However, these differences tended to be in less important line items (both in terems of size and use to an investor) that could be grouped into 'other' fields. 

Creating a model that worked for four companies provided us with a base to work with. Tweaking the model from here would involve scraping a much larger universe and lining up all the differences. 