class AddDisplaynameToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :displayname, :string
  end
end
