module V1
  class UsersController < V1Controller
    def show
      @user = User.find(params[:uniqname])
    rescue
      render template: "v1/errors/no_user", status: :bad_request
    end

    def update
      @user = User.find_or_create_by(uniqname: params[:uniqname].downcase)
      if @user.update(retain_history: params[:retain_history])
        redirect_to action: "show", uniqname: @user.uniqname
      else
        render template: "v1/errors/update_failed", status: :bad_request
      end
    end
  end
end
