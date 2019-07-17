class AddRegistrationReasonToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :registration_reason, :text
  end
end
