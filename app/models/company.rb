class Company < ApplicationRecord
  has_and_belongs_to_many :watchlists
  has_many :filings
  has_many :bs_yearly_results, through: :filings
  has_many :is_yearly_results, through: :filings
  has_many :cf_yearly_results, through: :filings
  has_many :dei_statement, through: :filings

  validates :ticker, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true

  def self.get_show_model_hash(ticker)
    company = self.find_by_ticker(ticker)

    response = {
      bs_yearly_results: [],
      cf_yearly_results: [],
      dei_statements: [],
      filings: [],
      is_yearly_results: []
    }

    # get most recent filings and push into filings array
    filing2016 = company.filings.last
    response['filings'] = [filing2016]
    # get filing's bs results and push into bs array
    response['bs_yearly_results'] = [filing2016.bs_yearly_results]
    # get filing's cf results and push into cf array
    response['cf_yearly_results'] = [filing2016.cf_yearly_results]
    # get filing's is results and push into is array
    response['is_yearly_results'] = [filing2016.is_yearly_results]
    # get filing's dei and push into dei array
    response['dei_statements'] = [filing2016.dei_statement]
    #

    # get filing 2 years earlier and push into filings array
    filing2014 = company.filings[-3]
    # get filing's bs results and push into bs array
    response['bs_yearly_results'].unshift(filing2014.bs_yearly_results)
    # get filing's dei and push into dei array
    response['dei_statements'].unshift(filing2014.dei_statement)

    # get filing 3 years earlier and push into filings array
    filing2013 = company.filings[-4]
    # get filing's cf results and push into cf array
    response['cf_yearly_results'].unshift(filing2013.cf_yearly_results)
    # get filing's is results and push into is array
    response['is_yearly_results'].unshift(filing2013.is_yearly_results)
    # get filing's dei and push into dei array
    response['dei_statements'].unshift(filing2013.dei_statement)

    # get filing 4 years earlier and push into filings array
    filing2012 = company.filings[-5]
    # get filing's bs results and push into bs array
    response['bs_yearly_results'].unshift(filing2012.bs_yearly_results)
    # get filing's dei and push into dei array
    response['dei_statements'].unshift(filing2012.dei_statement)

    response.each do |key, value|
      value.flatten!
      value = value.sort_by {|hash| hash[:year]}
    end

    # response.sort_by { |hash| hash['year'] }

    response
  end
end
