class ChangePermissionsAccessColumnToText < ActiveRecord::Migration[5.2]
  def change
    change_column :permissions, :access, :text
  end
end
