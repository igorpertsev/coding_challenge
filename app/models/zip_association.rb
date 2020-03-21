class ZipAssociation < ApplicationRecord
  def self.import_without_validation(data)
    transaction { import([:zip, :cbsa], data, validate: false, on_duplicate_key_ignore: true) }
  end
end
