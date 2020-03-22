module InformationService
  class Cbsa
    attr_reader :zip

    def initialize(zip)
      @zip = zip
    end

    def fetch
      return ::ZipAssociation::INVALID_ZIP unless zip_association

      mdiv_cbsa_association ? mdiv_cbsa_association.cbsa : zip_association.cbsa
    end

    def self.fetch(zip)
      new(zip).fetch
    end

    private

    def zip_association
      @zip_association ||= ::ZipAssociation.by_zip(zip).first
    end

    def mdiv_cbsa_association
      @mdiv_cbsa_association ||= ::MdivCbsaAssociation.by_mdiv(zip_association.cbsa).first
    end
  end
end
