Rails.application.routes.draw do

  get 'users/:id', to: "users#show"

  get 'companies/:id', to: "companies#show"

  # USERS
  get 'users/:id', to: "users#show"

  # COMPANIES
  get 'companies', to: "companies#index"
  get 'companies/model/:ticker', to: "companies#model_show"
  get 'companies/info/:ticker', to: "companies#sector_description"
  get 'companies/peerdata/:ticker', to: "companies#peer_data"

  # USERS
  get 'users/:id', to: "users#show"
  post 'register', to: "authentications#register"
  post 'login', to: "authentications#login"

  # WATCHLIST
  get 'watchlists/:id', to: "watchlists#show"
  post 'watchlists/:id/delete/:company_id', to: "watchlists#delete_company_from_watchlist"

  # FEEDS
  post 'watchlistfeed', to: "newsfeeds#watchlist_feed"
  post 'filingfeed', to: "rssfilings#filing_feed"
  post 'historicalprices', to: "historicalprices#historical_prices"

  # BS TESTING
  get 'bs_yearly_result', to: "bs_yearly_results#show"

  get 'companies/feed/:ticker', to: "newsfilingfeeds#feed"

  # EPS estimates from yahoo
  get 'companies/epsestimates/:ticker', to: "epsestimates#eps_estimates"

end
