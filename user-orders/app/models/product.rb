class Product < ApplicationRecord
    validates :code, presence: true, uniqueness: true
    validates :name, presence: true
    validates :category, presence: true

    def self.import_entries(file_path)
        CSV.foreach(file_path, headers: true) do |row|
            product_data = {
                code: row['CODE'],
                name: row['NAME'],
                category: row['CATEGORY']
            }

            product = Product.new(product_data)

            if product.save
                puts "CATEGORY #{product.code} imported successfully."
            else
                puts "Error importing product #{product.code}: #{product.errors.full_messages.join(', ')}"
            end
        end
    end
end
