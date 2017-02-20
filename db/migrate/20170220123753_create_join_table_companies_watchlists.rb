class CreateJoinTableCompaniesWatchlists < ActiveRecord::Migration[5.0]
  def change
    create_join_table :companies, :watchlists do |t|
      t.index [:company_id, :watchlist_id]
      t.index [:watchlist_id, :company_id]
    end
  end
end
