# Validation for login

module LoginParamValidation
    extend ActiveSupport::Concern

    private

    def validate_login_params
        errors = []

        # Required fields are present
        if params[:user].present?
            unless params[:user][:username].present?
                errors << { field: 'username', message: 'Username is required' }
            end
            
            unless params[:user][:password].present?
                errors << { field: 'password', message: 'Password is required' }
            end
            
            # Fields are in string format
            
            unless params[:user][:username].is_a?(String)
                errors << { field: 'username', message: 'Username is wrong data type' }
            end
            
            unless params[:user][:password].is_a?(String)
                errors << { field: 'password', message: 'Password is wrong data type'}
            end
        else
            errors << 'User Object not present'
        end

        # If there are errors, helt execution and send them to client

        if errors.present?
            render json: { errors: errors }, status: :unprocessable_entity
        end
    end
end