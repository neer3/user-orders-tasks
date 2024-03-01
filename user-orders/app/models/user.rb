class User < ApplicationRecord
    validates :username, presence: true, uniqueness: true
    validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
    # validates :phone, allow_blank: true, format: { with: /\A\d+\z/, message: 'Should only contain digits' }

    has_many :order_details

    def self.import_entries(file_path)
        CSV.foreach(file_path, headers: true) do |row|
            user_data = {
                username: row['USERNAME'],
                email: row['EMAIL'],
                phone: row['PHONE']
            }

            user = User.new(user_data)

            if user.save
                puts "User #{user.username} imported successfully."
            else
                puts "Error importing user #{user.username}: #{user.errors.full_messages.join(', ')}"
            end
        end
    end
end
