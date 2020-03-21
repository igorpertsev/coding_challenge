require 'csv'

module ImportService
  class Common
    attr_reader :zip_to_cbsa, :cbsa_to_msa, :errors

    def initialize(files)
      @zip_to_cbsa = files[:zip_to_cbsa]
      @cbsa_to_msa = files[:cbsa_to_msa]
      @errors = []
    end

    def import
      return { errors: errors } if invalid_import_request?

      ::ImportService::Zip.import(zip_to_cbsa)
      ::ImportService::Population.import(cbsa_to_msa)

      { status: :ok }
    end

    private

    def invalid_import_request?
      errors << 'Missing required parameter :zip_to_cbsa' if zip_to_cbsa.nil?
      errors << 'Missing required parameter :cbsa_to_msa' if cbsa_to_msa.nil?
      errors.present?
    end
  end
end
