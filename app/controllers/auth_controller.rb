require 'jwt'

class AuthController < ActionController::API
    include LoginParamValidation
    include CreateParamValidation
    include JwtAuth

    before_action :validate_login_params, only: [:login]
    before_action :validate_create_params, only: [:create]
    before_action :jwt_authenticate_request, only: [:testJwtAuthenticate]

    def testJwtAuthenticate
        render json: { user: @current_user }
    end

    def testLogin
        user = User.find_by(username: params[:user][:username])
        authenticated = user&.authenticate(params[:user][:password])

        if authenticated
            render json: { message: 'Credentials Valid' }
        else
            render json: { message: 'Invalid Credentials' }
        end
    end

    def login
        user = User.find_by(username: params[:user][:username])
        authenticated = user&.authenticate(params[:user][:password])

        if authenticated
            token = JWT.encode({ user_id: user.id, exp: 6.months.from_now.to_i }, ENV['SECRET_KEY_BASE'])
            render json: { token: token }
        else
            render json: { message: 'Invalid Credentials' }
        end
    end

    def create
        user = User.new({
            username: params[:newUsername],
            password: params[:newPassword],
            first_name: params[:firstName],
            last_name: params[:lastName],
            email: params[:email],
            note: params[:note],
            admin: false,
            approved: false
        })


        if user.save
            render json: { message: 'User added' }, status: :ok
        else
            render json: { 
                            message: 'User not added',
                            errors: user.errors.full_messages
                        }, status: :bad_request
        end
    end

end
