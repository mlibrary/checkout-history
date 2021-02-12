module V1
  class LoansController < ApplicationController
    def index
      @loans = LoansPresenter.new(user: User.find(params[:user_uniqname]))
      #render json: @loans
    end
  end
end

