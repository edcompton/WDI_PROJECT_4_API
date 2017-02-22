class BsYearlyResult < ApplicationRecord
  belongs_to :filing
  has_one :company, through: :filing

  def other_current_assets
    total_current_assets.to_i - cce.to_i - marketable_securities.to_i - short_term_investments.to_i - inventory.to_i - accounts_recievable.to_i
  end

  def total_non_current_assets
    total_assets.to_i - total_current_assets
  end

  def other_non_current_assets
    total_non_current_assets.to_i - avaiable_for_sale_securities.to_i - ppe_net.to_i - goodwill.to_i - other_intangible_assets.to_i
  end

  def other_current_liabilities
    total_current_liabilities.to_i - accounts_payable.to_i - accrued_expenses.to_i - short_term_debt.to_i - current_portion_of_long_term_debt.to_i - current_deferred_revenue.to_i
  end

  def stock_value_and_paid_in_capital
    stock_value.to_i + preferred_stock_value.to_i + additional_paid_in_capital.to_i
  end

  def total_liabilities
    total_liabilities_and_equity.to_i - total_equity.to_i
  end

  def total_non_current_liabilities
    total_liabilities.to_i - total_current_liabilities.to_i
  end

  def other_non_current_liabilities
    total_non_current_liabilities.to_i - long_term_debt.to_i - non_current_deferred_revenue.to_i - deferred_tax_liabilities.to_i
  end

  def other_equity
    total_equity.to_i - stock_value_and_paid_in_capital.to_i - retained_earnings.to_i - accumulated_other_comprehensive_income.to_i - treasury_stock.to_i - minority_interest.to_i
  end

  def net_working_capital
    inventory.to_i + accounts_recievable.to_i - accounts_payable.to_i
  end

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
