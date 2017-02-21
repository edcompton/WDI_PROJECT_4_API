class CreateCompanies < ActiveRecord::Migration[5.0]
  def change
    create_table :companies do |t|
      t.string :ticker
      t.string :name
      t.string :sector

      t.timestamps
    end
  end
end
