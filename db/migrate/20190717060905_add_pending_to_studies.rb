class AddPendingToStudies < ActiveRecord::Migration[5.2]
  def change
    add_column :studies, :pending, :boolean, default: true
  end
end
