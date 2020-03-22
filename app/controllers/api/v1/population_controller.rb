module Api
  module V1
    class PopulationController < ::ApplicationController
      def fetch
        render json: ::InformationService::Population.new(params[:zip]).run
      end
    end
  end
end
