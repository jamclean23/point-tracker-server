class IndexController < ActionController::API
    def status
        render json: { "status": "OK" }, status: :ok
    end
end
