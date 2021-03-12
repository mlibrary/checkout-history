class TestController < ActionController::Base
  include Prometheus::Controller
  def gauge
    GAUGE_EXAMPLE
      .set(rand(0..100), labels: {route: :gauge})
      Rails.logger.tagged("MRIO").info("Hiya")
    respond_to do |r|
      r.any do
        render json: {
          message: "Success", }, status: 200
      end
    end
  end
end

