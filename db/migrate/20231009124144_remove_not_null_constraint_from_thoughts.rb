class RemoveNotNullConstraintFromThoughts < ActiveRecord::Migration[7.0]
  def change
    change_column :thoughts, :user_id, :integer, null: true
  end
end
