module CheckoutHistoryLoader
  class Report
    include Enumerable

    def initialize(items)
      @items = items
    end

    def each(&block)
      @items.each(&block)
    end

    def self.for_rows(rows)
      new(rows.map { |x| ReportItem.new(x) })
    end

    def self.fetch
      rows = []
      response = AlmaRestClient.client.get_report(path: ENV.fetch("CIRC_REPORT_PATH")) do |row|
        rows.push ReportItem.new(row)
      end
      if response.status != 200
        raise FetchReportError, response.body
      end
      new(rows)
    end
  end
end
