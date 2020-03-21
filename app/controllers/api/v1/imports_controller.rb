module Api
  module V1
    class ImportsController < ::ApplicationController
      def common
        ::ImportService::Common.new(params[:files]).import
      end
    end
  end
end
