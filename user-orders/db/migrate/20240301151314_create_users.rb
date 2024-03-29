class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :phone

      t.timestamps
    end
    add_index :users, :username
    add_index :users, :email
  end
end
