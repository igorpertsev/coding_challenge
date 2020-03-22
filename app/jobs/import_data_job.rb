class ImportDataJob < ApplicationJob
  queue_as :default

  def perform(zip_to_cbsa, cbsa_to_msa)
    ::ImportService::Zip.import(zip_to_cbsa)
    ::ImportService::Population.import(cbsa_to_msa)

    File.delete(zip_to_cbsa) if File.exist?(zip_to_cbsa)
    File.delete(cbsa_to_msa) if File.exist?(cbsa_to_msa)

    Rails.cache.delete_matched("#{InformationService::Population.cache_key_base}*")
  end
end
