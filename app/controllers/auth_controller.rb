require 'jwt'

class AuthController < ActionController::API
    include LoginParamValidation
    include CreateParamValidation
    include JwtAuth

    before_action :validate_login_params, only: [:login]
    before_action :validate_create_params, only: [:create]
    before_action :jwt_authenticate_request, only: [:jwtAuthenticate, :delete]

    def jwtAuthenticate
        # Returns the user without the password hash
        render json: { user: @current_user.as_json(except: :password_digest) }
    end

    def testLogin
        user = User.find_by(username: params[:user][:username])
        authenticated = user&.authenticate(params[:user][:password])

        if authenticated
            render json: { message: 'Credentials Valid' }
            return
        else
            render json: { message: 'Invalid Credentials' }
            return
        end
    end

    def login
        user = User.find_by(username: params[:user][:username])
        authenticated = user&.authenticate(params[:user][:password])

        if !user
            render json: {errors: [{ field: 'serverMsg', message: 'User does not exist. Request access to make an account.' }]}
            return
        end

        if !user[:approved]
            render json: {errors: [{ field: 'serverMsg', message: 'User has not been approved. Contact your administrator to continue.' }]}
            return
        end

        if !user[:email_verified] && authenticated
            emailAuthToken = JWT.encode({ email: user[:email], exp: 30.minutes.from_now.to_i}, ENV['SECRET_KEY_BASE'])
            render json: {errors: [{ field: 'serverMsg', code: 'not_verified', email: user[:email], emailAuthToken: emailAuthToken }]}
            return
        end

        if authenticated
            token = JWT.encode({ user_id: user.id, exp: 6.months.from_now.to_i }, ENV['SECRET_KEY_BASE'])
            render json: { token: token }
            return
        else
            render json: { errors: [{ field: 'serverMsg', message: 'Invalid Password' }] }
            return
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
            approved: false,
            email_verified: false
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

    def delete
        if @current_user.destroy
            render json: { result: 'success' }, status: :ok
        else
            render json: { result: 'failed' }, status: :unprocessable_entity
        end
    end

    def sendVerificationEmail
        token = request.headers['Authorization']&.split&.last
        begin
            decodedToken = JWT.decode(token, ENV['SECRET_KEY_BASE'])
            email = decodedToken[0]['email'];
            token = JWT.encode({ email: email, exp: 30.minutes.from_now.to_i}, ENV['SECRET_KEY_BASE'])
            VerificationMailer.verification_email(email, token).deliver_now
            render json: { result: 'sent' }
        rescue JWT::DecodeError, JWT::VerificationError, JWT::ExpiredSignature => e
            render json: { result: 'expired' }
        end
    end

    def verifyEmail
        token = params[:jwt]

        begin
            decodedToken = JWT.decode(token, ENV['SECRET_KEY_BASE'])
            email = decodedToken[0]['email']
            user = User.find_by(email: email);
            if user
                puts user
                user.update(email_verified: true)
                render plain: 'Email Verified'
            else
                render plain: 'Email not verified, please try again'
            end

        rescue JWT::DecodeError, JWT::VerificationError, JWT::ExpiredSignature => e
            render plain: 'Expired or Invalid link'
        end
    end

    def queryVerified
        token = request.headers['Authorization']&.split&.last
        begin
            decodedToken = JWT.decode(token, ENV['SECRET_KEY_BASE'])
            email = decodedToken[0]['email']

            user = User.find_by(email: email)

            if user && user[:email_verified]
                render json: { verified: true }
            else
                render json: { verified: false }
            end

        rescue JWT::DecodeError, JWT::VerificationError, JWT::ExpiredSignature => e
            render json: { status: 'expired' }
        end
    end

end
