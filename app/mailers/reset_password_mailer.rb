# Send a link to password reset page with jwt 

class ResetPasswordMailer < ApplicationMailer
  def reset_password(email, token)
    @token = token
    mail(to: email, from: ENV["MAILER_USERNAME"], subject: 'PointTracker: Reset Password')
  end
end