module V1
  class UsersController < ApplicationController
    def show
      @user = User.find(params[:uniqname])
      render json: @user
    end
    def update
      @user = User.find(params[:uniqname])
      if @user.update(retain_history: params[:retain_history])
        redirect_to  action: 'show', uniqname: @user.uniqname
      else
        #error?
      end
    end
  end
end

