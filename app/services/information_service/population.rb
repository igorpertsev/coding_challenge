module InformationService
  class Population
    DEFAULT_LSAD = 'Metropolitan Statistical Area'.freeze

    attr_reader :zip

    def initialize(zip)
      @zip = zip
    end

    def run
      cbsa = fetch_cbsa
      return no_cbsa_response unless cbsa
      build_response(cbsa, fetch_population_info(cbsa))
    end

    private

    def fetch_cbsa
      zip_association = ::ZipAssociation.by_zip(zip).first
      return unless zip_association

      mdiv_cbsa_association = ::MdivCbsaAssociation.by_mdiv(zip_association.cbsa).first
      if mdiv_cbsa_association
        mdiv_cbsa_association.cbsa
      else
        zip_association.cbsa
      end
    end

    def fetch_population_info(cbsa)
      ::PopulationInformation.by_cbsa(cbsa).by_lsad(DEFAULT_LSAD).first
    end

    def build_response(cbsa, population)
      return no_population_response(cbsa) unless population

      population.as_json.merge(zip: zip)
    end

    def no_population_response(cbsa)
      ::PopulationInformation.empty_response.merge(zip: zip, cbsa: cbsa)
    end

    def no_cbsa_response
      ::PopulationInformation.empty_response.merge(zip: zip, cbsa: ::ZipAssociation::INVALID_ZIP)
    end
  end
end
