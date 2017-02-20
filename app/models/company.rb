class Company < ApplicationRecord
  has_and_belongs_to_many :watchlists
  has_many :filings
end
