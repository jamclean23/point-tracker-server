class VerificationMailer < ApplicationMailer
  def verification_email(email, token)
    @token = token
    mail(to: email, from: ENV["MAILER_USERNAME"], subject: 'Verify your Point Tracker Email')
  end
end