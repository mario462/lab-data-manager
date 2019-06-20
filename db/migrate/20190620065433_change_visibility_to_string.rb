class ChangeVisibilityToString < ActiveRecord::Migration[5.2]
  def change
    change_column :studies, :visibility, :string
  end
end
