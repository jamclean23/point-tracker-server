# Initialize listener for users table

require_relative '../../app/listeners/users_listener'

Thread.new do
  loop do
    begin
      users_listener = UsersListener.new
      users_listener.listen
    rescue => e
      Rails.logger.error "Error in UsersListener: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      sleep 10  # Wait before restarting
    end
  end
end
