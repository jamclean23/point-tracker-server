require 'pg'

class UsersListener
    def initialize
        @conn = ActiveRecord::Base.connection.raw_connection
    end

    def listen
        puts 'Started listener for users table'
        @conn.exec("LISTEN approval_update")

        loop do
            @conn.wait_for_notify do |channel, pid, payload|
                handle_notification(payload)
            end
        end
    ensure
        @conn.close
    end

    private

    def handle_notification(id)
        puts "Received approval update notification for user with id: #{id}"
        user = User.find_by(id: id)
        if (!user.nil?)
            if (user.approved == true)
                puts 'User ' + id.to_s + ' approved'
                ApprovalMailer.approved_email(user[:email]).deliver_later
            elsif (user.approved == false)
                puts 'User ' + id.to_s + ' approval revoked'
                ApprovalMailer.revoked_email(user[:email]).deliver_later
            end 
        end
    end
end
