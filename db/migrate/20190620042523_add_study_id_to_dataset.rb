class AddStudyIdToDataset < ActiveRecord::Migration[5.2]
  def change
    add_column :datasets, :study_id, :integer
  end
end
