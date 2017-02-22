class AddStockValuePeferedStockValueAndAdditionalPaidInCapitalToBsYearlyResults < ActiveRecord::Migration[5.0]
  def change
    add_column :bs_yearly_results, :stock_value, :float
    add_column :bs_yearly_results, :preferred_stock_value, :float
    add_column :bs_yearly_results, :additional_paid_in_capital, :float
  end
end
