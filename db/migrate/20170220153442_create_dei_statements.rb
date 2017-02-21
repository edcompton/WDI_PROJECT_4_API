class CreateDeiStatements < ActiveRecord::Migration[5.0]
  def change
    create_table :dei_statements do |t|
      t.references :filing, foreign_key: true
      t.integer :year
      t.string :share_units
      t.string :monetary_units
      t.string :document_type
      t.boolean :amendment_flag
      t.string :document_period_end_date
      t.integer :document_fiscal_year_focus
      t.string :document_fiscal_period_focus
      t.string :trading_symbol
      t.string :entity_registrant_name
      t.integer :entity_central_index_key
      t.string :current_fiscal_year_end_date
      t.boolean :entity_well_known_seasoned_issuer
      t.boolean :entity_current_reporting_status
      t.boolean :entity_voluntary_filers
      t.string :entity_filer_category
      t.float :entity_common_stock_shares_outstanding
      t.float :entity_public_float

      t.timestamps
    end
  end
end
