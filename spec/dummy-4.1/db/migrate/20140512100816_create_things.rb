class CreateThings < ActiveRecord::Migration
  def change
    create_table :things do |t|
      t.integer :position, :null => false
      t.timestamps
    end

    add_index :things, [:position]
  end
end
