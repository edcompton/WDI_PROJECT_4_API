class Company < ApplicationRecord
  has_and_belongs_to_many :watchlists
  has_many :filings

  validates :ticker, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true
end
