require 'csv'

class OrderHistoryExportWorker
    include Sidekiq::Worker

    def perform(user_id)
        user = User.find_by(id: user_id)
        return unless user

        in_progress_export_status = ExportStatus.find_by(user_id: user.id, status: 'started')

        return if in_progress_export_status.present?

        file_path = "data/#{user.username}_order_history.csv"

        export_status = ExportStatus.create(user_id: user.id, status: 'started', file_path: file_path)

        begin
            order_details = user.order_details.includes(:product)

            csv_data = CSV.generate do |csv|
                csv << ['USERNAME', 'USER_EMAIL', 'PRODUCT_CODE', 'PRODUCT_NAME', 'PRODUCT_CATEGORY', 'ORDER_DATE']

                order_details.each do |order_detail|
                    csv << [user.username, user.email, order_detail.product.code, order_detail.product.name, order_detail.product.category, order_detail.order_date.strftime('%d-%m-%Y')]
                end
            end

            File.open("public/#{file_path}", 'w') { |file| file.write(csv_data) }

            export_status.update(status: 'completed')
        rescue StandardError => e
            export_status.update(status: 'failed')
        end
    end
end
