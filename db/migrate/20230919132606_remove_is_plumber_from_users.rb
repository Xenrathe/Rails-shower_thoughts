class RemoveIsPlumberFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :is_plumber, :boolean
  end
end
