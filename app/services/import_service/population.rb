module ImportService
  class Population < Base
    protected

    def truncate_existing_data
      ActiveRecord::Base.connection.execute("TRUNCATE #{::PopulationInformation.table_name} RESTART IDENTITY")
      ActiveRecord::Base.connection.execute("TRUNCATE #{::MdivCbsaAssociation.table_name} RESTART IDENTITY")
    end

    def parse_csv
      import_data = []
      mdiv_data = []

      ::CSV.foreach(csv_path, headers: true, skip_blanks: true, encoding:'iso-8859-1:utf-8') do |row|
        next if row['CBSA'].nil?

        mdiv_data << [row['CBSA'], row['MDIV']] if row['MDIV']
        import_data << ::PopulationInformation::IMPORT_FIELDS.map { |(_, header)| row.fetch(header) }

        import_data = persist_data_batch(import_data, ::PopulationInformation) if import_data.size >= BATCH_SIZE
        mdiv_data = persist_data_batch(mdiv_data, ::MdivCbsaAssociation) if mdiv_data.size >= BATCH_SIZE
      end
      persist_data_batch(import_data, ::PopulationInformation) if import_data.size >= 0
      persist_data_batch(mdiv_data, ::MdivCbsaAssociation) if mdiv_data.size >= 0
    end
  end
end
