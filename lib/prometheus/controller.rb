module Prometheus
  module Controller
    prometheus = Prometheus::Client.registry

    GAUGE_EXAMPLE = Prometheus::Client::Gauge.new(:gauge_example, docstring: "A simple guage that rands between 1 and 100 inclusively.", labels: [:route])

    prometheus.register(GAUGE_EXAMPLE)
  end
end
