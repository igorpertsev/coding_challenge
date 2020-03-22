class PopulationInformation < ApplicationRecord
  IMPORT_FIELDS = {
    cbsa: 'CBSA',
    name: 'NAME',
    lsad: 'LSAD',
    pop_2010: 'POPESTIMATE2010',
    pop_2011: 'POPESTIMATE2011',
    pop_2012: 'POPESTIMATE2012',
    pop_2013: 'POPESTIMATE2013',
    pop_2014: 'POPESTIMATE2014',
    pop_2015: 'POPESTIMATE2015'
  }.freeze

  scope :by_cbsa, ->(cbsa) { where(cbsa: cbsa) }
  scope :by_lsad, ->(lsad) { where(lsad: lsad) }

  def self.import_without_validation(data)
    transaction { import(IMPORT_FIELDS.keys, data, validate: false, on_duplicate_key_ignore: true) }
  end

  def self.empty_response
    IMPORT_FIELDS.each_with_object({}) { |(field, _), result| result[field] = 'N/A' }
  end
end
