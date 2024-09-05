module CookieJwtAuth
  extend ActiveSupport::Concern
  private

  def cookie_jwt_authenticate
    token = cookies.signed[:jwt]
    puts 'Authenticating JWT from cookie'
    puts token

    begin
      # Decode token
      decoded_token = JWT.decode(token, ENV['SECRET_KEY_BASE'])
      user_id = decoded_token[0]['user_id']
      user = User.find_by(id: user_id)

      puts 'USER:'
      puts user

      # Set instance user
      if user
        @current_user = user
      end
    rescue => e
      puts 'Error occurred'
      puts e.message
      @current_user = nil
    end
  end
end