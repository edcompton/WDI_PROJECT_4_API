class CreateIsYearlyResults < ActiveRecord::Migration[5.0]
  def change
    create_table :is_yearly_results do |t|
      t.references :filing, foreign_key: true
      t.integer :year
      t.string :date, :unit
      t.float :sales,
        :cogs,
        :ebit,
        :pbt,
        :tax,
        :net_income,
        :basic_eps,
        :diluted_eps

      t.timestamps
    end
  end
end
