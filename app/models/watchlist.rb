class Watchlist < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :companies

  validates :user_id, presence: true
end
