class BsYearlyResultSerializer < ActiveModel::Serializer
  attributes :id,
  :filing_id,
  :year,
  :date,
  :unit,
  :cce,
  :marketable_securities,
  :short_term_investments,
  :inventory,
  :accounts_recievable,
  :total_current_assets,
  :avaiable_for_sale_securities,
  :ppe_net,
  :goodwill,
  :other_intangible_assets,
  :total_assets,
  :accounts_payable,
  :accrued_expenses,
  :short_term_debt,
  :current_portion_of_long_term_debt,
  :current_deferred_revenue,
  :total_current_liabilities,
  :long_term_debt,
  :non_current_deferred_revenue,
  :deferred_tax_liabilities,
  :total_liabilities,
  :common_stocks_and_paid_in_capital,
  :retained_earnings,
  :accumulated_other_comprehensive_income,
  :treasury_stock,
  :minority_interest,
  :total_equity,
  :total_liabilities_and_equity,
  :stock_value,
  :preferred_stock_value,
  :additional_paid_in_capital,
  :other_current_assets,
  :total_non_current_assets,
  :other_non_current_assets,
  :other_current_liabilities,
  :stock_value_and_paid_in_capital,
  :total_liabilities,
  :total_non_current_liabilities,
  :other_non_current_liabilities,
  :other_equity,
  :net_working_capital

  # def other_current_assets
  #   object.total_current_assets.to_i - object.cce.to_i - object.marketable_securities.to_i - object.short_term_investments.to_i - object.inventory.to_i - object.accounts_recievable.to_i
  # end
  #
  # def total_non_current_assets
  #   object.total_assets.to_i - object.total_current_assets
  # end
  #
  # def other_non_current_assets
  #   object.total_non_current_assets.to_i - object.avaiable_for_sale_securities.to_i - object.ppe_net.to_i - object.goodwill.to_i - object.other_intangible_assets.to_i
  # end
  #
  # def other_current_liabilities
  #   object.total_current_liabilities.to_i - object.accounts_payable.to_i - object.accrued_expenses.to_i - object.short_term_debt.to_i - object.current_portion_of_long_term_debt.to_i - object.current_deferred_revenue.to_i
  # end
  #
  # def stock_value_and_paid_in_capital
  #   object.stock_value.to_i + object.preferred_stock_value.to_i + object.additional_paid_in_capital.to_i
  # end
  #
  # def total_liabilities
  #   object.total_liabilities_and_equity.to_i - object.total_equity.to_i
  # end
  #
  # def total_non_current_liabilities
  #   object.total_liabilities.to_i - object.total_current_liabilities.to_i
  # end
  #
  # def other_non_current_liabilities
  #   object.total_non_current_liabilities.to_i - object.long_term_debt.to_i - object.non_current_deferred_revenue.to_i - object.deferred_tax_liabilities.to_i
  # end
  #
  # def other_equity
  #   object.total_equity.to_i - object.stock_value_and_paid_in_capital.to_i - object.retained_earnings.to_i - object.accumulated_other_comprehensive_income.to_i - object.treasury_stock.to_i - object.minority_interest.to_i
  # end
  #
  # def net_working_capital
  #   object.inventory.to_i + object.accounts_recievable.to_i - object.accounts_payable.to_i
  # end
end
