class CreateCfYearlyResults < ActiveRecord::Migration[5.0]
  def change
    create_table :cf_yearly_results do |t|
      t.references :filing, foreign_key: true
      t.integer :year
      t.string :date, :unit
      t.float :net_income,
        :d_and_a,
        :amortisation,
        :share_compensation,
        :deferred_tax,
        :change_in_op_assets_and_liabilities,
        :inventories,
        :receivables,
        :payables,
        :net_cash_from_operating_activities,
        :capex,
        :disposal_of_ppe,
        :purchases_of_marketable_securities,
        :proceeds_from_sales_of_marketable_securities,
        :proceeds_from_maturities_of_marketable_securities,
        :acquisitions,
        :disposals,
        :net_cash_used_in_investing_activities,
        :issuance_of_stock,
        :total_debt_issued,
        :total_debt_repayments,
        :long_term_debt_raised,
        :long_term_debt_repayments,
        :net_short_term_debt_issued,
        :payment_of_dividends,
        :stock_repurchases,
        :net_cash_from_financing_activities,
        :effect_of_fx_on_cash_and_cash_equicalents,
        :net_change_in_cash

      t.timestamps
    end
  end
end
