Rails.application.routes.draw do

  get 'users/:id', to: "users#show"
  get 'users', to: "users#index"

  get 'companies/:id', to: "companies#show"

  # COMPANIES
  get 'companies', to: "companies#index"
  # USERS
  get 'users/:id', to: "users#show"

  get 'companies/model/:ticker', to: "companies#model_show"

  post 'register', to: "authentications#register"
  post 'login', to: "authentications#login"

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
