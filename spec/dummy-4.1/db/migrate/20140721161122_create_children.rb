class CreateChildren < ActiveRecord::Migration
  def up
    create_table :children do |t|
      t.string :name, :null => false
      t.integer :parent_id, :null => false
      t.integer :position, :null => false
      t.timestamps
    end

    add_index :children, [:position]
  end

  def down
    drop_table :children
  end
end
