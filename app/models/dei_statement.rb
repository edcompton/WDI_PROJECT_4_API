class DeiStatement < ApplicationRecord
  belongs_to :filing
  has_one :company, through: :filing
end
