module Api
  module V1
    class PopulationController < ::ApplicationController
      def fetch
        render json: ::InformationService::Population.fetch(params[:zip])
      end
    end
  end
end
