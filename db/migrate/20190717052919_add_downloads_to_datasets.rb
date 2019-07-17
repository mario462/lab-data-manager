class AddDownloadsToDatasets < ActiveRecord::Migration[5.2]
  def change
    add_column :datasets, :downloads, :integer, default: 0
  end
end
