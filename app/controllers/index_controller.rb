class IndexController < ActionController::API
    require 'pg'
    $points_db_config = {
        host: ENV['POINTS_DB_ENDPOINT'],
        dbname: ENV['POINTS_DB_NAME'],
        user: ENV['POINTS_DB_USERNAME'],
        password: ENV['POINTS_DB_PASSWORD']
    }
    include JwtAuth

    before_action :jwt_authenticate_request, only: [:getSites]

    def status
        render json: { "status": "OK" }, status: :ok
    end

    def getSites
        puts 'Getting Sites'

        begin
            conn = PG.connect($points_db_config)

            query = 
                <<-SQL
                    SELECT operations.*, clients.*
                    FROM operations
                    INNER JOIN clients ON operations.client_uid = clients.client_uid
                SQL

            result = conn.exec(query)

            unless result.is_a?(PG::Result)
                puts 'Result wrong type'
                render json: {error: 'Error contacting database'}, status: :internal_server_error
                return
            end

            sites = result.map do |row|
                row
            end
            render json: { "sites": sites}
            return
        rescue => e
            puts e
            render json: {error: e}, status: :internal_server_error
            return
        ensure
            conn.close if conn
        end
        
    end
end
