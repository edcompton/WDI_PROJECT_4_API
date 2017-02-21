class CreateFilings < ActiveRecord::Migration[5.0]
  def change
    create_table :filings do |t|
      t.string :accession_id
      t.references :company, foreign_key: true

      t.timestamps
    end
  end
end
