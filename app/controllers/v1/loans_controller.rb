module V1
  class LoansController < ApplicationController
    def index
      user = User.find(params[:user_uniqname])
    rescue
      render template: "v1/errors/no_user", status: :bad_request
    else
      @loans = LoansPresenter.new(user: user,
        limit: params[:limit], offset: params[:offset],
        order_by: params[:order_by], direction: params[:direction])

      # render json: @loans
    end

    def download
      user = User.find_or_create_by_uniqname(params[:user_uniqname])
      loans = Loan.where(user: user)
      respond_to do |format|
        format.csv {
          send_data loans.to_csv,
            filename: "circulation_history_#{Date.today}.csv"
        }
      end
    end
  end
end
