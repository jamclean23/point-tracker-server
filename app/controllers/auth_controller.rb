class AuthController < ActionController::API
    include LoginParamValidation
    include CreateParamValidation

    before_action :validate_login_params, only: [:login]
    before_action :validate_create_params, only: [:create]


    def login

        puts "LOGIN ATTEMPT"
        puts params[:username]
        puts params[:password]
        render json: {}, status: :ok

    end

    def create
        puts params
        render json: {}, status: :ok
    end

end
