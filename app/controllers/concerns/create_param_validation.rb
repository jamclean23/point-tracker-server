# Validation for account creation

module CreateParamValidation
    extend ActiveSupport::Concern

    private

    def validate_create_params
        
        # Array of errors will be returned to client
        errors = []
        
        # NEW USERNAME VALIDATION
        
        # Config
        usernameConfig = {
            min: 8,
            max: 20,
            required: true
        }
        
        # Required and must be a string
        
        unless params[:newUsername] && params[:newUsername].length > 0 && usernameConfig[:required]
            errors << { field: 'newUsername', message: 'Username is required'}
        end
        
        unless params[:newUsername] && params[:newUsername].is_a?(String)
            errors << { field:  'newUsername', message: 'Username is wrong data type, must be string'}
        end
        
        # If exists and is a string, perform more validation 
        if params[:newUsername] && params[:newUsername].is_a?(String)        
            
            # Min length
            unless params[:newUsername].length >= usernameConfig[:min]
                errors << { field: 'newUsername', message: 'Username must be at least ' + usernameConfig[:min].to_s + ' characters'}
            end
            
            # Max length 
            unless params[:newUsername].length <= usernameConfig[:max]
                errors << { field: 'newUsername', message: 'Username may not exceed ' + usernameConfig[:max].to_s + ' characters' }
            end
            
            # Special characters
            unless /^[a-zA-Z\d]+$/.match?(params[:newUsername])
                errors << { field: 'newUsername', message: 'No special characters or spaces'}
            end
        end
        
        
        # NEW PASSWORD VALIDATION
        
        # Config
        newPasswordConfig = {
            min: 8,
            max: 20
        }

        # Required and must be a string
        
        unless params[:newPassword] && params[:newPassword].length > 0
            errors << { field: 'newPassword', message: 'Password is required'}
        end
        
        unless params[:newPassword] && params[:newPassword].is_a?(String)
            errors << { field:  'newPassword', message: 'Password is wrong data type, must be string'}
        end
        
        # If exists and is a string, perform more validation
        
        if params[:newPassword] && params[:newPassword].is_a?(String)
            
            # Min length
            unless params[:newPassword].length >= usernameConfig[:min]
                errors << { field: 'newPassword', message: 'Password must be at least ' + usernameConfig[:min].to_s + ' characters'}
            end

            # Max length 
            unless params[:newPassword].length <= usernameConfig[:max]
                errors << { field: 'newPassword', message: 'Password may not exceed ' + usernameConfig[:max].to_s + ' characters' }
            end

            # No spaces
            unless !/\s/.match?(params[:newPassword])
                errors << { field: 'newPassword', message: 'Password may not contain spaces' } 
            end
        end


        # CONFIRM PASSWORD VALIDATION

        # Required and must be a string

        unless params[:confirmPassword] && params[:confirmPassword].length > 0
            errors << { field: 'confirmPassword', message: 'Confirm password is required'}
        end

        unless params[:confirmPassword] && params[:confirmPassword].is_a?(String)
            errors << { field:  'confirmPassword', message: 'Confirm password is wrong data type, must be string'}
        end

        # If exists and is a string, perform more validation
        
        if params[:confirmPassword] && params[:confirmPassword].is_a?(String)

            # Matches newPassword
            unless params[:confirmPassword] == params[:newPassword]
                errors << { field: 'confirmPassword', message: 'Passwords do not match'}
            end
        end


        # FIRST AND LAST NAME VALIDATION
        
        def validateName(name = '', field = 'name', config = {
            min: 1,
            max: 30,
            required: true
        })


            # Fail conditions

            unless field.is_a?(String)
                raise 'Field argument is not a string'
            end

            unless config.is_a?(Hash)
                raise 'config argument is not a hash'
            end

            unless config[:min].is_a?(Numeric)
                raise 'config.min must be a Number'
            end

            unless config[:max].is_a?(Numeric)
                raise 'config.max must be a Number'
            end

            # Validation

            nameErrors = []

            unless name.is_a?(String)
                nameErrors << { field: field, message: field + ' must be a string' }
            end

            if name.is_a?(String)
                unless name && name.length > 0 && config[:required]
                    nameErrors << { field: field, message: field + ' is required' }
                end

                unless name.length >= config[:min] || name.length == 0
                    nameErrors << { field: field, message: field + ' must be at least ' + config[:min].to_s + ' characters' }
                end

                unless name.length <= config[:max]
                    nameErrors << { field: field, message: field + ' must be fewer than ' + config[:max].to_s + ' characters' }
                end

                # Special characters
                unless /^[a-zA-Z\d]+$/.match?(name) || name.length == 0
                    nameErrors << { field: field, message: 'No special characters or spaces'}
                end
                
            end

            
            return nameErrors


        end
        
        errors.concat(firstNameErrors = validateName(
            params[:firstName],
            'firstName',
            {
                min: 1,
                max: 30,
                required: true
            }
        ) || [])

        errors.concat(lastNameErrors = validateName(
            params[:lastName],
            'lastName',
            {
                min: 1,
                max: 30,
                required: true
            }
        ) || [])


        #  EMAIL VALIDATION

        def validateEmail(email, config = {
            required: true
        })

            # Fail conditions

            unless email.is_a?(String)
                raise 'Email must be a string'
            end
            
            unless config.is_a?(Hash)
                raise 'config must be a Hash'
            end

            # Validation

            emailErrors = []

            unless config[:required] && email.length > 1
                emailErrors << { field: 'email', message: 'May not be blank' }
            end

            unless email.match?(/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+$/)
                emailErrors << { field: 'email', message: 'Not valid email format' }
            end

            return emailErrors
        end
        
        errors.concat(validateEmail(
            params[:email],
            {
                required: true
            }
        ) || [])


        # PHONE NUMBER VALIDATION

        def validatePhone(phoneNum, config = {
            min: 10,
            max: 20,
            required: true
        })

            # Fail conditions

            unless phoneNum.is_a?(String)
                raise 'phoneNum must be a String'
            end

            unless config.is_a?(Hash)
                raise 'config must be a Hash'
            end


            # Validation

            phoneErrors = []
            
            if phoneNum.length == 0 && config[:required]
                phoneErrors << { field: 'phoneNum', message: 'Phone number may not be blank' }
            end

            unless phoneNum.match?(/^[\d]+$/) || phoneNum.length == 0
                phoneErrors << { field: 'phoneNum', message: 'Only digits allowed' }
            end

            unless phoneNum.length >= config[:min]
                phoneErrors << { field: 'phoneNum', message: 'Must be at least ' + config[:min].to_s + ' digits' }
            end

            unless phoneNum.length <= config[:max]
                phoneErrors << { field: 'phoneNum', message: 'Must be ' + config[:max].to_s  + ' digits or less' }
            end


            return phoneErrors

        end

        errors.concat(validatePhone(
            params[:phoneNum],
            {
                required: false,
                min: 10,
                max: 20
            }
        ) || [])



        # NOTE VALIDATION

        def validateNote(note, config = {
            required: false,
            min: 0,
            max: 2000
        })

            # Fail conditions

            unless note.is_a?(String)
                raise 'Note must be a String'
            end

            unless config.is_a?(Hash)
                raise 'config must be a Hash'
            end


            # Validation

            noteErrors = []

            if config[:required] && note.length == 0
                noteErrors << { field: 'note', message: 'Note is required' }
            end

            if config[:required] && note.length <= config[:min] && note.length != 0
                noteErrors << { field: 'notes', message: 'Note must be at least ' + config[:min].to_s + ' characters' }
            end

            if note.length >= config[:max]
                noteErrors << { field: 'notes', message: 'Note must be ' + config[:max].to_s + ' characters or fewer' }
            end


            return noteErrors
        end

        errors.concat(validateNote(
            params[:note],
            {
                required: false,
                min: 0,
                max: 2000
            }
        ) || [])


        # If there are errors, send them back to client

        if errors.present?
            render json: { errors: errors }, status: :unprocessable_entity
        end
    end
end