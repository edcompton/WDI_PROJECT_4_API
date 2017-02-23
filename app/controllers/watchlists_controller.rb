class WatchlistsController < ApplicationController

  def show
    tickers = User.get_watchlist_tickers params['id']
    render json: {tickers: tickers}
  end

  def add_company_to_watchlist
    Watchlist.add_company_to_watchlist params["company_id"], params["id"]
  end

  def delete_company_from_watchlist
    Watchlist.delete_company_from_watchlist params["company_id"], params["id"]
  end
end
