class UsersController < ApplicationController

    before_action :authenticate_user

    def show

        pp current_user
        render json: current_user
    end
end
