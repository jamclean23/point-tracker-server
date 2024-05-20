# Validation for login

module LoginParamValidation
    extend ActiveSupport::Concern

    private

    def validate_login_params
        errors = []

        puts 'PERFORMING CREATE VALIDATION'

        # Required fields are present

        unless params[:username].present?
            errors << { field: 'username', message: 'Username is required' }
        end

        unless params[:password].present?
            errors << { field: 'password', message: 'Password is required' }
        end

        # Fields are in string format

        unless params[:username].is_a?(String)
            errors << { field: 'username', message: 'Username is wrong data type' }
        end

        unless params[:password].is_a?(String)
            errors << { field: 'password', message: 'Password is wrong data type'}
        end

        # If there are errors, helt execution and send them to client

        if errors.present?
            render json: { errors: errors }, status: :unprocessable_entity
        end
    end
end