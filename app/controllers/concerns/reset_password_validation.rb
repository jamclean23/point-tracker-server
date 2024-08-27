module ResetPasswordValidation
  extend ActiveSupport::Concern
  private

  def validate_email
    #  EMAIL VALIDATION

    email = params[:email]
    errors = []

    # Fail conditions
    
    unless email.is_a?(String)
      errors << 'Email must be a string'
    end

    # Validation

    unless email.length > 1
      errors << 'May not be blank'
    end

    unless email.match?(/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+$/)
      errors << 'Not valid email format'
    end

    if errors.present?
      render json: {error: errors.join('. ')}
    end
  end
end