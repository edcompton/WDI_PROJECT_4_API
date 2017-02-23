class IsYearlyResult < ApplicationRecord
  belongs_to :filing
  has_one :company, through: :filing

  # def gross_profit
  #   sales - cogs
  # end
  #
  # def opex
  #   gross_profit - ebit
  # end
  #
  # def finance_and_other_expenses
  #   ebit - pbt
  # end
  #
  # def other_adjustments
  #   pbt - net_income - tax
  # end
  #
  # def basic_shares
  #   net_income / basic_eps
  # end

  # def sales_growth
  #
  # end
  #
  # def ebit_growth
  #
  # end
  #
  # def diluted_eps_growth
  #
  # end
end
