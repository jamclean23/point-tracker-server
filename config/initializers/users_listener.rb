# Initialize listener for users table

require_relative '../../app/listeners/users_listener'

Thread.new do
  begin
    users_listener = UsersListener.new
    users_listener.listen
  rescue => e
    Rails.logger.error "Error starting UsersListener: #{e.message}"
    raise e  # Ensure the error is raised to stop the thread in case of an error
  end
end
