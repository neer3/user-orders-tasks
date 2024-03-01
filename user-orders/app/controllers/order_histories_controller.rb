class OrderHistoriesController < ApplicationController
    def fetch_order_histories
        users_with_orders = User.includes(:order_details).where.not(order_details: { id: nil }).distinct.pluck(:id, :email, :username)

        json_response = {
            links: {
                self: '/order_histories',
            },
            data: users_with_orders.map { |id, username, email| { id: id, username: username, email: email } }
        }

        render json: json_response
    end

    def export
        user_id = params[:user_id]
        OrderHistoryExportWorker.perform_async(user_id)
    
        render json: { message: 'Export job has been initiated. Check back later for the download link.' }
    end

    def export_status
        user_id = params[:user_id]
        user = User.find_by(id: user_id)
    
        return render json: { status: 'not_found' }, status: :not_found unless user
    
        export_status = ExportStatus.order(created_at: :desc).find_by(user_id: user.id)
        
        if export_status.present? && export_status.status == 'completed'
          render json: { status: export_status.status, file_path: export_status.file_path }
        else
          render json: { status: 'initiated' }
        end
    end
end
