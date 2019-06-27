class ChangeDatasetsAttachmentAndDataToString < ActiveRecord::Migration[5.2]
  def change
    change_column :datasets, :attachment, :string
    change_column :datasets, :data, :string
  end
end
