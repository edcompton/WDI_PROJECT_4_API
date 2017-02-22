class BsYearlyResult < ApplicationRecord
  belongs_to :filing
  has_one :company, through: :filing

  # def other_current_assets
  #   total_current_assets - cce - marketable_securities - short_term_investments - inventory - accounts_recievable
  # end
  #
  # def total_non_current_assets
  #   total_assets - total_current_assets
  # end
  #
  # def other_non_current_assets
  #   total_non_current_assets - avaiable_for_sale_securities - ppe_net - goodwill - other_intangible_assets
  # end
  #
  # def other_current_liabilities
  #   total_current_liabilities - accounts_payable - accrued_expenses - short_term_debt - current_portion_of_long_term_debt - current_deferred_revenue
  # end
  #
  # def stock_value_and_paid_in_capital
  #
  # end
  #
  # def total_liabilities
  #   total_liabilities_and_equity - total_equity
  # end
  #
  # def total_non_current_liabilities
  #   total_liabilities - total_current_liabilities
  # end
  #
  # def other_non_current_liabilities
  #   total_non_current_liabilities - long_term_debt - non_current_deferred_revenue - deferred_tax_liabilities
  # end
  #
  # def other_equity
  #
  # end
  #
  # def net_working_capital
  #   inventory + accounts_recievable - accounts_payable
  # end

  # before_save :log_out_missing_fields

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
