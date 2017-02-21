class AddYearToFiling < ActiveRecord::Migration[5.0]
  def change
    add_column :filings, :year, :integer
  end
end
