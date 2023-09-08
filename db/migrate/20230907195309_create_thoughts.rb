class CreateThoughts < ActiveRecord::Migration[7.0]
  def change
    create_table :thoughts do |t|

      t.datetime :post_time
      t.string :title
      t.string :content
      t.string :highlight_mode
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :thoughts, :highlight_mode
  end
end
