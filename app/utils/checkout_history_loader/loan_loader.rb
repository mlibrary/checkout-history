module CheckoutHistoryLoader
  class LoanLoader
    def initialize(report_item:, user:, loan:)
      @report_item = report_item
      @user = user
      @loan = loan
    end

    def has_identical_checkout_date?
      @loan.checkout_date&.to_date&.to_fs(:db) == @report_item.checkout_date
    end

    def load
      return if @loan.return_date.present?
      return if @report_item.return_date.blank?

      @loan.tap do |l|
        l.user = @user
        l.id = @report_item.id
        l.title = @report_item.title
        l.author = @report_item.author
        l.mms_id = @report_item.mms_id
        l.return_date = @report_item.return_date
        l.checkout_date = @report_item.checkout_date
        l.barcode = @report_item.barcode
        l.call_number = @report_item.call_number
        l.description = @report_item.description
      end

      if @loan.save
        Rails.logger.info("item_loan '#{@loan.id}' saved")
      else
        Rails.logger.error("item_loan '#{@loan.id}' not saved: #{@loan.errors.full_messages}")
        raise LoanLoadError, @loan.errors.full_messages
      end
    end

    def self.load(report_item)
      user = User.find_or_create_by_uniqname(report_item.uniqname)
      unless user.retain_history
        Rails.logger.warn("item_loan '#{report_item.id}' not saved: patron opt out")
        return
      end
      loan = Loan.find_or_create_by(id: report_item.id)
      new(report_item: report_item, user: user, loan: loan).load
    end
  end
end
