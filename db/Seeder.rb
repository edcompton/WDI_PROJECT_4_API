class Seeder
  def get_onclick_terms_file
    YAML.load_file(File.open('./scrapers/onclick_terms.yml'))
  end

  def print_bs
    onclick_terms = @onclick_terms_file["balance_sheet"]
    bs = BalanceSheetScraper.new @file, onclick_terms
    @bs = bs.return_data
    Pry::ColorPrinter.pp @bs
  end

  def print_cf
    onclick_terms = @onclick_terms_file["cashflow_statement"]
    cf = CashflowStatementScraper.new @file, onclick_terms
    @cf = cf.return_data
    Pry::ColorPrinter.pp @cf
  end

  def print_dei
    onclick_terms = @onclick_terms_file["cover_sheet"]
    dei = DocumentAndEntityInformationScraper.new @file, onclick_terms
    @dei = dei.return_data
    Pry::ColorPrinter.pp @dei
  end

  def print_is
    onclick_terms = @onclick_terms_file["income_statement"]
    is = IncomeStatementScraper.new @file, onclick_terms
    @is = is.return_data
    Pry::ColorPrinter.pp @is
  end

  def test_type_and_print type
    case type
    when 'BS'
        print_bs
      when 'CF'
        print_cf
      when 'DEI'
        print_dei
      when 'IS'
        print_is
    end
  end

  def parse_file
    details = @file_path.split('/')[-1].split('_')
    ticker = details[0]
    year = details[1]
    accession_id = details[2]
    type = details[-1].split('.')[0]
    test_type_and_print type
  end

  def initialize file_paths
    file_paths.each do |file_path|
      @file_path = file_path
      @onclick_terms_file = get_onclick_terms_file
      @file = File.open @file_path
      parse_file
    end
  end
end
