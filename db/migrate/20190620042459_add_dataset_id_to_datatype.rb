class AddDatasetIdToDatatype < ActiveRecord::Migration[5.2]
  def change
    add_column :data_types, :dataset_id, :integer
  end
end
