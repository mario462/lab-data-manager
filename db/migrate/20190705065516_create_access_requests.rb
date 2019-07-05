class CreateAccessRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :access_requests do |t|
      t.integer :study_id
      t.integer :user_id
      t.text :motivation

      t.timestamps
    end
  end
end
