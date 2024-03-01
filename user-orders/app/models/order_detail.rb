class OrderDetail < ApplicationRecord
	belongs_to :product
	belongs_to :user

	validates :product_id, presence: true
	validates :user_id, presence: true
	validates :order_date, presence: true

	def self.import_entries(file_path)
		CSV.foreach(file_path, headers: true) do |row|
			user_email = row['USER_EMAIL']
			product_code = row['PRODUCT_CODE']
			order_date = row['ORDER_DATE']

			user = User.find_by(email: user_email)

			product = Product.find_by(code: product_code)

			if user && product
				order_data = {
					user_id: user.id,
					product_id: product.id,
					order_date:
				}
		
				order_detail = OrderDetail.new(order_data)
		
				if order_detail.save
					puts "OrderDetail for User: #{user_email}, Product: #{product_code} imported successfully."
				else
					puts "Error importing order_detail for User: #{user_email}, Product: #{product_code}: #{order_detail.errors.full_messages.join(', ')}"
				end
			else
				puts "User with email: #{user_email} or Product with code: #{product_code} not found."
			end
		end
	end
end