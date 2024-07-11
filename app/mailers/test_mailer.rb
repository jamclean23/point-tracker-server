# Send a test email to ensure configuration is correct
class TestMailer < ApplicationMailer
  def test_email(email)
    mail(to: email, from: ENV["MAILER_USERNAME"], subject: 'Welcome to My Awesome Site')
  end
end