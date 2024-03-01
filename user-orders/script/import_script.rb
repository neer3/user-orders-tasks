class DataImporter
    attr_reader :users_csv_path, :products_csv_path, :order_details_csv_path
    def initialize
        @users_csv_path = 'data/users.csv'
        @products_csv_path = 'data/products.csv'
        @order_details_csv_path = 'data/order_details.csv'
    end

    def start
        clear_data
        import_users
        import_products
        import_order_details
    end

    private

    def clear_data
        puts 'Clearing existing data...'
        
        OrderDetail.delete_all

        User.delete_all
        Product.delete_all
        
        puts 'Data cleared successfully.'
    end
  
    def import_users
        puts 'Importing users...'
        import_data(users_csv_path, User)
        puts 'Users imported successfully.'
    end
  
    def import_products
        puts 'Importing products...'
        import_data(products_csv_path, Product)
        puts 'Products imported successfully.'
    end
  
    def import_order_details
        puts 'Importing order details...'
        import_data(order_details_csv_path, OrderDetail)
        puts 'Order details imported successfully.'
    end
  
    def import_data(file_path, model)
        model.import_entries(file_path)
    rescue StandardError => e
        puts "Error importing #{model.name}: #{e.message}"
    end
end

data_importer = DataImporter.new
data_importer.start
