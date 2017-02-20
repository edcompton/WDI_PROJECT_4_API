class Filing < ApplicationRecord
  belongs_to :company
  has_many :bs_yearly_results

  validates :accession_id, presence: true, uniqueness: true
end
