class Filing < ApplicationRecord
  belongs_to :company

  validates :accession_id, presence: true, uniqueness: true
end
