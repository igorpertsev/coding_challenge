require 'csv'

module ImportService
  class Base
    attr_accessor :csv_path

    BATCH_SIZE = 1500.freeze

    def initialize(file_path)
      @csv_path = file_path
    end

    def import
      truncate_existing_data
      parse_csv
    end

    def self.import(file_path)
      new(file_path).import
    end

    protected

    def truncate_existing_data
      raise NotImplemented
    end

    def parse_csv
      raise NotImplemented
    end

    def persist_data_batch(import_data, klass)
      klass.import_without_validation(import_data)
      []
    end
  end
end
