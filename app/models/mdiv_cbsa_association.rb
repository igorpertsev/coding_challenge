class MdivCbsaAssociation < ApplicationRecord
  scope :by_mdiv, ->(mdiv) { where(mdiv: mdiv) }

  def self.import_without_validation(data)
    transaction { import([:cbsa, :mdiv], data, validate: false, on_duplicate_key_ignore: true) }
  end
end
