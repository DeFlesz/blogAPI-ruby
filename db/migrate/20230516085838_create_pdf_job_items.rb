class CreatePdfJobItems < ActiveRecord::Migration[7.0]
  def change
    create_table :pdf_job_items do |t|
      t.string :filepath
      t.string :status
      t.integer :ref
      t.string :t

      t.timestamps
    end
  end
end
