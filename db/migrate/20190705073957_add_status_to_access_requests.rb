class AddStatusToAccessRequests < ActiveRecord::Migration[5.2]
  def change
    add_column :access_requests, :status, :integer, default: 100
  end
end
