class ChangePermissionsAccessToInteger < ActiveRecord::Migration[5.2]
  def change
    change_column :permissions, :access, :integer
  end
end
