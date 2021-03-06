class ApplicationController < ActionController::API

    include  Knock::Authenticable

    def ping

        if current_user
            render json: { response: "Authorized pong"} 
        else
            render json: { response: "Error - Unauthorized"} 
        end
    end

end
