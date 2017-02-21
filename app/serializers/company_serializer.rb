class CompanySerializer < ActiveModel::Serializer
  attributes :id, :ticker, :name, :filings, :bs_yearly_results, :is_yearly_results, :cf_yearly_results, :dei_statement
end
