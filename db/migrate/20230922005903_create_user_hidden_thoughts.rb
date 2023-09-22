class CreateUserHiddenThoughts < ActiveRecord::Migration[7.0]
  def change
    create_table :user_hidden_thoughts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :thought, null: false, foreign_key: true

      t.timestamps
    end
  end
end
