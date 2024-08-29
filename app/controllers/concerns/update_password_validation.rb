module UpdatePasswordValidation
  extend ActiveSupport::Concern
  private

  def validate_password
    # Password validation
    unless params[:password] && params[:password].length > 0
      render json: { result: 'failed', message: 'Password is required'}
    end
    
    unless params[:password] && params[:password].is_a?(String)
        render json: { result: 'failed', message: 'Password is wrong data type, must be string'}
    end
    
    # If exists and is a string, perform more validation
    
    if params[:password] && params[:password].is_a?(String)
        
        # Min length
        unless params[:password].length >= 8
            render json: { result: 'failed', message: 'Password must be at least 8 characters'}
        end

        # Max length 
        unless params[:password].length <= 20
            render json: { result: 'failed', message: 'Password may not exceed 20 characters' }
        end

        # No spaces
        unless !/\s/.match?(params[:password])
            render json: { result: 'failed', message: 'Password may not contain spaces' } 
        end
      end
    end
end