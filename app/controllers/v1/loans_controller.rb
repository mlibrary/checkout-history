module V1
  class LoansController < ApplicationController
    def index
      @loans = LoansPresenter.new(user: User.find(params[:user_uniqname]))
      #render json: @loans
    end
    def download
      user = User.find(params[:user_uniqname])
      loans = Loan.where(user: user)
      respond_to do |format|
        format.csv { send_data loans.to_csv, 
                     filename: "#{user.uniqname}_circ_history_#{Date.today}.csv"
        }
      end
        
    end
  end
end

