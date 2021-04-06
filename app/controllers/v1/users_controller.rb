module V1
  class UsersController < ApplicationController
    def show
      @user = User.find_or_create_by_uniqname(params[:uniqname])
    end
    def update
      @user = User.find(params[:uniqname].downcase)
      if @user.update(retain_history: params[:retain_history])
        redirect_to  action: 'show', uniqname: @user.uniqname
      else
        #error?
      end
    end
  end
end

