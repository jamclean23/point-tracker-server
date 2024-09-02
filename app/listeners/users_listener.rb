require 'pg'

class UsersListener
    def initialize
        connect
    end

    def connect
        @conn = ActiveRecord::Base.connection.raw_connection
    end

    def listen
        puts 'Started listener for users table'
        @conn.exec("LISTEN approval_update")

        loop do
            begin
                @conn.wait_for_notify do |channel, pid, payload|
                    handle_notification(payload)
                end
            rescue PG::Error => e
                Rails.logger.error "Connection lost: #{e.message}"
                sleep 5  # Small delay before reconnecting
                Rails.logger.info 'Reconnecting to PostgreSQL...'
                connect
                retry
            end
        end
    end

    private

    def handle_notification(id)
        puts "Received approval update notification for user with id: #{id}"
        user = User.find_by(id: id)
        if user
            if user.approved
                puts "User #{id} approved"
                ApprovalMailer.approved_email(user.email).deliver_later
            else
                puts "User #{id} approval revoked"
                ApprovalMailer.revoked_email(user.email).deliver_later
            end
        end
    end
end
