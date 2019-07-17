class AddPendingToDatasets < ActiveRecord::Migration[5.2]
  def change
    add_column :datasets, :pending, :boolean, default: true
  end
end
