class LoansPresenter
  attr_reader :count
  def initialize(user:, limit: 10, offset: 0)
    @list = user.loans.limit(limit).offset(offset)
    @count = user.loans.all.count
  end

  def map(&block)
    @list.map do |l|
      block.call(l)
    end
  end
end
