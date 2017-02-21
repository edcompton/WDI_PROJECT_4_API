class BsYearlyResult < ApplicationRecord
  belongs_to :filing
  has_one :company, through: :filing

  before_save :log_out_missing_fields

  private
    def log_out_missing_fields
      # loop over nill fields and return keys and log
      # APPLE
        # missing fields {
        #   SALES: [
        #   "_SalesRevenueNet\'",
        #   "_SalesRevenueGoodsNet\'",
        #   "_Revenues\'"
        #   ],
        #   COGS: [
        #   "_CostOfGoodsAndServicesSold\'",
        #   "_CostOfGoodsSold\'",
        #   "_CostOfRevenue\'"
        #   ],
        # }
    end
end
