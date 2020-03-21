require 'csv'

module ImportService
  class Common
    attr_reader :zip_to_cbsa, :cbsa_to_msa

    BATCH_SIZE = 1500.freeze
    INVALID_ZIP = '99999'.freeze

    def initialize(files)
      @zip_to_cbsa = files[:zip_to_cbsa]
      @cbsa_to_msa = files[:cbsa_to_msa]
    end

    def import
      ActiveRecord::Base.connection.execute("TRUNCATE #{::ZipAssociation.table_name} RESTART IDENTITY")
      ActiveRecord::Base.connection.execute("TRUNCATE #{::PopulationInformation.table_name} RESTART IDENTITY")
      ActiveRecord::Base.connection.execute("TRUNCATE #{::MdivCbsaAssociation.table_name} RESTART IDENTITY")

      build_zip_associations
      build_cbsa_to_msa
    end

    private

    def build_zip_associations
      import_data = []

      ::CSV.foreach(zip_to_cbsa.path, headers: true) do |row|
        import_data << row[0..1] unless row[1] == INVALID_ZIP
        import_data = persist_zip_data(import_data) if import_data.size >= BATCH_SIZE
      end

      persist_zip_data(import_data) if import_data.size >= 0
    end

    def persist_zip_data(import_data)
      ::ZipAssociation.import_without_validation(import_data)
      []
    end

    def build_cbsa_to_msa
      import_data = []
      mdiv_data = []
      x = 0

      ::CSV.foreach(cbsa_to_msa.path, headers: true, skip_blanks: true, liberal_parsing: true, encoding:'iso-8859-1:utf-8') do |row|
        if row['CBSA']
          mdiv_data << [row['CBSA'], row['MDIV']] if row['MDIV']
          import_data << ::PopulationInformation::IMPORT_FIELDS.map { |(_, header)| row.fetch(header) }

          import_data = persist_population_data(import_data) if import_data.size >= BATCH_SIZE
          mdiv_data = persist_mdiv_data(mdiv_data) if mdiv_data.size >= BATCH_SIZE
        end
        p x += 1
      end

      persist_population_data(import_data) if import_data.size >= 0
      persist_mdiv_data(mdiv_data) if mdiv_data.size >= 0
    end

    def persist_population_data(import_data)
      ::PopulationInformation.import_without_validation(import_data)
      []
    end

    def persist_mdiv_data(import_data)
      ::MdivCbsaAssociation.import_without_validation(import_data)
      []
    end
  end
end
