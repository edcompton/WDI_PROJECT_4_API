class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: true
  has_one :watchlist

  def self.get_watchlist user_id
    user = User.find(user_id)
    watchlist = Watchlist.find(user)
    watchlist
  end

  def self.get_watchlist_tickers user_id
    user = User.find(user_id)
    ids = Watchlist.find(user).company_ids
    @companies = Company.find(ids)
    for company in @companies
      company.ticker
    end
  end
end
