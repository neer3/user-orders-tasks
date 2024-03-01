class CreateExportStatuses < ActiveRecord::Migration[7.0]
  def change
    create_table :export_statuses do |t|
      t.references :user, null: false, foreign_key: true
      t.string :status
      t.string :file_path
      t.string :error_message

      t.timestamps
    end
  end
end
