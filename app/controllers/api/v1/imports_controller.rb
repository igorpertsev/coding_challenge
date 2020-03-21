module Api
  module V1
    class ImportsController < ::ApplicationController
      def common
        result = ::ImportService::Common.new(required_params).import
        render json: result, status: status_from_result(result)
      end

      private

      def status_from_result(result)
        result[:error].present? ? 404 : 200
      end

      def required_params
        params.require(:files).permit(:zip_to_cbsa, :cbsa_to_msa)
      end
    end
  end
end
