module CheckoutHistoryLoader
  class ReportItem
    def initialize(row)
      @row = row
    end

    def uniqname
      @row["User Primary Identifier"]
    end

    def id
      @row["Item Loan Id"]
    end

    def title
      @row["Title"]&.slice(0, 255)
    end

    def author
      @row["Author"]&.slice(0, 255)
    end

    def mms_id
      @row["MMS Id"]
    end

    def checkout_date
      @row["Loan Date"]
    end

    def return_date
      @row["Return Date"]
    end

    def barcode
      @row["Barcode"]
    end

    def call_number
      @row["Call Number"]
    end

    def description
      @row["Description"]
    end
  end
end
