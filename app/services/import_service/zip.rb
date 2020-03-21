module ImportService
  class Zip < Base
    protected

    def truncate_existing_data
      ActiveRecord::Base.connection.execute("TRUNCATE #{::ZipAssociation.table_name} RESTART IDENTITY")
    end

    def parse_csv
      import_data = []

      ::CSV.foreach(csv.path, headers: true, skip_blanks: true, encoding:'iso-8859-1:utf-8') do |row|
        next if row[1] == INVALID_ZIP

        import_data << row[0..1]
        import_data = persist_data_batch(import_data, ::ZipAssociation) if import_data.size >= BATCH_SIZE
      end

      persist_data_batch(import_data, ::ZipAssociation) if import_data.size >= 0
    end
  end
end
