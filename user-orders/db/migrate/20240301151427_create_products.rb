class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :code
      t.string :name
      t.string :category

      t.timestamps
    end
    add_index :products, :code
  end
end
