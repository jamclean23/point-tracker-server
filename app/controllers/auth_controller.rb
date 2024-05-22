class AuthController < ActionController::API
    include LoginParamValidation
    include CreateParamValidation

    before_action :validate_login_params, only: [:login]
    before_action :validate_create_params, only: [:create]


    def login
        render json: {}, status: :ok
    end

    def create
        render json: {}, status: :ok
    end

end
