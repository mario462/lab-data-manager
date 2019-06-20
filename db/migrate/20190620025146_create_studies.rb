class CreateStudies < ActiveRecord::Migration[5.2]
  def change
    create_table :studies do |t|
      t.string :name
      t.text :description
      t.string :url
      t.integer :visibility

      t.timestamps
    end
  end
end
