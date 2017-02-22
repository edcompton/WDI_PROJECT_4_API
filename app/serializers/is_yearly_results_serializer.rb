class IsYearlyResultsSerializer < ActiveModel::Serializer
  attributes :id, :filing_id

  # :year, :date, :unit, :sales, :cogs, :ebit, :pbt, :tax, :net_income, :basic_eps, :diluted_eps,
  # :gross_profit, :opex, :finance_and_other_expenses, :other_adjustments, :basic_shares

  def gross_profit
    sales - cogs
  end

  def opex
    gross_profit - ebit
  end

  def finance_and_other_expenses
    ebit - pbt
  end

  def other_adjustments
    pbt - net_income - tax
  end

  def basic_shares
    net_income / basic_eps
  end
end
