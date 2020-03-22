module InformationService
  class Population
    DEFAULT_LSAD = 'Metropolitan Statistical Area'.freeze

    attr_reader :zip

    def initialize(zip)
      @zip = zip
    end

    def fetch
      return insufficient_data_response unless cbsa && cbsa != ::ZipAssociation::INVALID_ZIP
      build_response(fetch_population_info(cbsa))
    end

    def self.fetch(zip)
      new(zip).fetch
    end

    private

    def cbsa
      @cbsa ||= ::InformationService::Cbsa.fetch(zip)
    end

    def fetch_population_info(cbsa)
      ::PopulationInformation.by_cbsa(cbsa).by_lsad(DEFAULT_LSAD).first
    end

    def build_response(population)
      return insufficient_data_response unless population

      population.as_json.merge(zip: zip)
    end

    def insufficient_data_response
      ::PopulationInformation.empty_response.merge(zip: zip, cbsa: cbsa)
    end
  end
end
