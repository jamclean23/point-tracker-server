module JwtAuth
    extend ActiveSupport::Concern
    private

    def jwt_authenticate_request
        token = request.headers['Authorization']&.split&.last
        if token
            begin
                decoded_token = JWT.decode(token, ENV['SECRET_KEY_BASE'])
                user_id = decoded_token[0]['user_id']
                user = User.find_by(id: user_id)

                # If the user has been approved, set the user. Otherwise, render an error
                if !user
                    render json: { errors: [{ field: 'serverMsg', message: 'User not found' }]}
                    return
                elsif !user[:approved]
                    render json: { errors: [{ field: 'serverMsg', message: 'User has not been approved. Contact your administrator to continue' }] }
                    return
                elsif user[:approved]
                    @current_user = user
                else
                    render json: { errors: [{ field: 'serverMsg', message: 'Invalid token'}] }
                    return
                end

            rescue JWT::DecodeError
                render json: { errors: [{ field: 'serverMsg', message: 'Invalid token' }] }, status: :unauthorized
                return
            end
        else
            render json: { errors: [{ field: 'serverMsg', message: 'Token not provided' }] }, status: :unauthorized
            return
        end
    end
end
  