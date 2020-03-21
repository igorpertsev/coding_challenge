class MdivCbsaAssociation < ApplicationRecord
  def self.import_without_validation(data)
    transaction { import([:cbsa, :mdiv], data, validate: false, on_duplicate_key_ignore: true) }
  end
end
