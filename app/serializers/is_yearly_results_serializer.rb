class IsYearlyResultsSerializer < ActiveModel::Serializer
  attributes :id, :filing_id, :year, :date, :unit, :sales, :cogs, :ebit, :pbt, :tax, :net_income, :basic_eps, :diluted_eps,
  :gross_profit, :opex, :finance_and_other_expenses, :other_adjustments, :basic_shares
end
