class AddHiddenToAccessRequest < ActiveRecord::Migration[5.2]
  def change
    add_column :access_requests, :hidden, :boolean, default: false
  end
end
