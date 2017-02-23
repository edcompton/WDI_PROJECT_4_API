class CompaniesController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    companies = Company.all
    render json: companies
  end

  def model_show
    ticker = params['ticker']
    show_model_hash = Company.get_show_model_hash ticker
    render json: show_model_hash
  end

  def sector_description
    ticker = params['ticker']
    company = Company.find_by({ticker: ticker})
    render json: {
      name: company.name,
      description: company.description,
      sector: company.sector
    }
  end

  def peer_data
    # companies = Company.all
    # companies.each do |x|
    #   puts x.sector
    # end
    ticker = params['ticker']
    company = Company.find_by({ticker: ticker})
    sector = company.sector
    peers = Company.where({sector: sector})
    peerTickers = []
    peerTickers << {
      name: company.name,
      ticker: ticker,
      IS: Company.find_EPS(ticker)
    }
    peers.each do |peer|
      if peer.name != company.name
        puts Company.find_EPS(peer.ticker)
        peerTickers << {
          name: peer.name,
          ticker: peer.ticker,
          IS: Company.find_EPS(peer.ticker)
        }
      end
    end
    render json: { data: peerTickers }
  end
end
