class CreateDatasets < ActiveRecord::Migration[5.2]
  def change
    create_table :datasets do |t|
      t.string :name
      t.text :description
      t.binary :attachment
      t.binary :data
      t.integer :year
      t.string :url
      t.integer :number_subjects
      t.string :pipeline
      t.text :quotation

      t.timestamps
    end
  end
end
