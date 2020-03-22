class ZipAssociation < ApplicationRecord
  INVALID_ZIP = '99999'.freeze

  scope :by_zip, ->(zip) { where(zip: zip) }

  def self.import_without_validation(data)
    transaction { import([:zip, :cbsa], data, validate: false, on_duplicate_key_ignore: true) }
  end
end
