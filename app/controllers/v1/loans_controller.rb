module V1
  class LoansController < ApplicationController
    def index
      @loans = User.find(params[:user_uniqname]).loans
      render json: @loans
    end
  end
end

