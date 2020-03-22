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

      ImportDataJob.perform_later(persist_temp_file(zip_to_cbsa),
                                  persist_temp_file(cbsa_to_msa))

      { status: :ok }
    end

    private

    def persist_temp_file(file)
      path = Rails.root.join('tmp', file.original_filename)
      FileUtils.cp(file.tempfile.path, path)
      path.to_s
    end

    def invalid_import_request?
      errors << 'Missing required parameter :zip_to_cbsa' if zip_to_cbsa.nil?
      errors << 'Missing required parameter :cbsa_to_msa' if cbsa_to_msa.nil?
      errors.present?
    end
  end
end
