class CreateBsYearlyResults < ActiveRecord::Migration[5.0]
  def change
    create_table :bs_yearly_results do |t|
      t.references :filing, foreign_key: true
      t.integer :year
      t.string :date, :unit
      t.float :cce,
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
      :total_liabilities_and_equity

      t.timestamps
    end
  end
end
