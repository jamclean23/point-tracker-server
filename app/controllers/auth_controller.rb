require 'jwt'

class AuthController < ActionController::Base
    include LoginParamValidation
    include CreateParamValidation
    include JwtAuth
    include ResetPasswordValidation
    include UpdatePasswordValidation
    include CookieJwtAuth

    before_action :validate_login_params, only: [:login]
    before_action :validate_create_params, only: [:create]
    before_action :jwt_authenticate_request, only: [:jwtAuthenticate, :delete]
    before_action :validate_email, only: [:passwordReset]
    before_action :validate_password, only: [:passwordChange]
    before_action :cookie_jwt_authenticate, only: [:adminDashboardPage]
    skip_before_action :verify_authenticity_token

    def jwtAuthenticate
        # Returns the user without the password hash
        render json: { user: @current_user.as_json(except: :password_digest) }
    end

    def passwordReset
        email = params[:email]
        user = User.find_by(email: email)
        token = JWT.encode({ email: email, exp: 30.minutes.from_now.to_i}, ENV['SECRET_KEY_BASE'])

        if user
            ResetPasswordMailer.reset_password(email, token).deliver_now
            render json: {result: 'success'}
            return
        else
            render json: {error: 'User with email does not exist'}
        end

    end

    def resetPasswordPage
        @jwt = params[:jwt]
        render 'reset_password/index'
    end

    def passwordChange
        token = request.headers['Authorization']&.split&.last
        begin
            decodedToken = JWT.decode(token, ENV['SECRET_KEY_BASE'])

            email = decodedToken[0]['email']
            user = User.find_by(email: email)

            if user
                user.password = params[:password]
                if user.save
                    render json: { result: 'success', message: 'Password updated successfully.'}
                else
                    render json: { result: 'failed', message: 'An error occurred. Please try again or contact an administrator.'}
                end
            else
                render json: { result: 'failed', message: 'User not found.'}
            end
        rescue JWT::DecodeError, JWT::VerificationError, JWT::ExpiredSignature => e
            render json: { result: 'expired', message: 'Invalid or expired token.' }
        rescue StandardError => e
            render json: { result: 'failed', message: 'An error occurred. Please try again or contact an administrator.'}
        end
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
        user = User.find_by(username: params[:user][:username].strip.downcase)
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
            username: params[:newUsername].strip.downcase,
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

    def adminDashboardPage
        if @current_user
            render 'admin_dashboard/index'
        else
            render 'admin_dashboard_login/index'
        end
    end

    def webLogin
        user = User.find_by(username: params[:username].strip.downcase)

        unless user
            render json: { result: 'failed', messages: [{field: 'serverMessage', message: 'User does not exist'}] }
            return
        end

        authenticated = user&.authenticate(params[:password])

        if authenticated
            
            token = JWT.encode({ user_id: user.id, exp: 6.months.from_now.to_i }, ENV['SECRET_KEY_BASE'])

            puts 'SETTING COOKIE'

            cookies.signed[:jwt] = {
                value: token,               # JWT token
                httponly: true,             # Prevent access from JavaScript
                secure: false, # CHANGE TO TRUE IF USING HTTPS
                same_site: :strict,         # CSRF protection
                expires: 24.hour.from_now    # Expiration time
            }


            render json: { result: 'success' }
            return
        else
            render json: { result: 'failed', messages: [{field: 'serverMessage', message: 'Incorrect password'}] }
            return
        end
    end

    def webLogout
        cookies.delete(:jwt, {
            httponly: true,               # Ensure it matches the cookie properties
            secure: false, # CHANGE TO TRUE IF USING HTTPS
            same_site: :strict             # Match the same_site flag if used
        })
          
        redirect_to '/auth/admin_dashboard'
    end

end
