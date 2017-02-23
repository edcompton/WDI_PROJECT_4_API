class WatchlistsController < ApplicationController

  def show
    tickers = User.get_watchlist_tickers params['id']
    p tickers, "watchlist controllllll"
    render json: {tickers: tickers}
  end

  def add_company_to_watchlist company_ticker, user_id
    Watchlist.add_company_to_watchlist(company_ticker, user_id)
  end

  def delete_company_from_watchlist
    p params
    Watchlist.delete_company_from_watchlist params["company_id"], params["id"]
  end
end
