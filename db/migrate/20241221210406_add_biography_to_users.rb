class AddBiographyToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :biography, :text
  end
end
