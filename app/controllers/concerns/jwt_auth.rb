module JwtAuth
    extend ActiveSupport::Concern
    private

    def jwt_authenticate_request
        token = request.headers['Authorization']&.split&.last
        if token
            begin
                decoded_token = JWT.decode(token, ENV['SECRET_KEY_BASE'])
                user_id = decoded_token[0]['user_id']
                @current_user = User.find_by(id: user_id)
            rescue JWT::DecodeError
                render json: { error: 'Invalid token' }, status: :unauthorized
            end
        else
            render json: { error: 'Token not provided' }, status: :unauthorized
        end
    end
end
  