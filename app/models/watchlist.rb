class Watchlist < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :companies

  validates :user_id, presence: true

  def self.add_company_to_watchlist company_ticker, user_id
    company_id = Company.find_company_by_ticker(company_ticker)
    watchlist = User.get_watchlist(user_id)
    watchlist.company_ids.push(company_id)
    watchlist.save
  end

  def self.delete_company_from_watchlist company_ticker, user_id
    company = Company.find_company_by_ticker(company_ticker)
    p company
    watchlist = User.get_watchlist(user_id)
    p watchlist
    if watchlist
      company.watchlists.delete(watchlist)
    end
  end
  
end
