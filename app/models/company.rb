class Company < ApplicationRecord
  has_and_belongs_to_many :watchlists
  has_many :filings
  has_many :bs_yearly_results, through: :filings
  has_many :is_yearly_results, through: :filings
  has_many :cf_yearly_results, through: :filings
  has_many :dei_statement, through: :filings

  validates :ticker, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true
end
