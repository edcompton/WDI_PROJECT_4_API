require 'yaml'

@onclick_terms = YAML.load_file(File.open('/Users/henrydavies/development/WDI_PROJECT_4_API/db/scrapers/onclick_terms.yml'))

bs = @onclick_terms['income_statement']


bs['SALES'].each do |title_phrase|
  p title_phrase
  p bs['SALES'].last
end
