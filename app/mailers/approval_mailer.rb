class ApprovalMailer < ApplicationMailer
  def approved_email(email)
    mail(to: email, from: ENV["MAILER_USERNAME"], subject: 'Approval Status Change')
  end
  def revoked_email(email)
    mail(to: email, from: ENV["MAILER_USERNAME"], subject: 'Approval Status Change')
  end
end