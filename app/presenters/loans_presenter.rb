class LoansPresenter
  attr_reader :count
  def initialize(user:, limit: 15, offset: 0, direction: "ASC", order_by: "checkout_date")
    @order_by = protect_order_by(order_by) || "checkout_date"
    @direction = protect_direction(direction) || "ASC"
    @order = "#{@order_by} #{@direction}"
    @limit = (limit || 15).to_i
    @offset = (offset || 0).to_i

    @list = user.loans.order(@order).limit(@limit).offset(@offset)
    @count = user.loans.all.count
  end

  def map(&block)
    @list.map do |l|
      block.call(l)
    end
  end

  private

  def protect_order_by(order_by)
    ["checkout_date", "return_date", "title", "author", "call_number"].include?(order_by) ? order_by : nil
  end

  def protect_direction(direction)
    ["ASC", "DESC"].include?(direction) ? direction : nil
  end
end
