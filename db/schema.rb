# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170220145655) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bs_yearly_results", force: :cascade do |t|
    t.integer  "filing_id"
    t.integer  "year"
    t.string   "date"
    t.string   "unit"
    t.float    "cce"
    t.float    "marketable_securities"
    t.float    "short_term_investments"
    t.float    "inventory"
    t.float    "accounts_recievable"
    t.float    "total_current_assets"
    t.float    "avaiable_for_sale_securities"
    t.float    "ppe_net"
    t.float    "goodwill"
    t.float    "other_intangible_assets"
    t.float    "total_assets"
    t.float    "accounts_payable"
    t.float    "accrued_expenses"
    t.float    "short_term_debt"
    t.float    "current_portion_of_long_term_debt"
    t.float    "current_deferred_revenue"
    t.float    "total_current_liabilities"
    t.float    "long_term_debt"
    t.float    "non_current_deferred_revenue"
    t.float    "deferred_tax_liabilities"
    t.float    "total_liabilities"
    t.float    "common_stocks_and_paid_in_capital"
    t.float    "retained_earnings"
    t.float    "accumulated_other_comprehensive_income"
    t.float    "treasury_stock"
    t.float    "minority_interest"
    t.float    "total_equity"
    t.float    "total_liabilities_and_equity"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.index ["filing_id"], name: "index_bs_yearly_results_on_filing_id", using: :btree
  end

  create_table "companies", force: :cascade do |t|
    t.string   "ticker"
    t.string   "name"
    t.string   "sector"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "companies_watchlists", id: false, force: :cascade do |t|
    t.integer "company_id",   null: false
    t.integer "watchlist_id", null: false
    t.index ["company_id", "watchlist_id"], name: "index_companies_watchlists_on_company_id_and_watchlist_id", using: :btree
    t.index ["watchlist_id", "company_id"], name: "index_companies_watchlists_on_watchlist_id_and_company_id", using: :btree
  end

  create_table "filings", force: :cascade do |t|
    t.string   "accession_id"
    t.integer  "company_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["company_id"], name: "index_filings_on_company_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "first_name"
    t.string   "last_name"
  end

  create_table "watchlists", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_watchlists_on_user_id", using: :btree
  end

  add_foreign_key "bs_yearly_results", "filings"
  add_foreign_key "filings", "companies"
  add_foreign_key "watchlists", "users"
end
