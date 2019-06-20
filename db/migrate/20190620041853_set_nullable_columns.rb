class SetNullableColumns < ActiveRecord::Migration[5.2]
  def change
    change_column :studies, :url, :string, :null => true
    change_column :datasets, :url, :string, :null => true
    change_column :datasets, :attachment, :binary, :null => true
    change_column :datasets, :pipeline, :string, :null => true
    change_column :datasets, :quotation, :text, :null => true
  end
end
