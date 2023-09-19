class AddPlumberStatusToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :plumber_status, :text, default: 'No'
  end
end
