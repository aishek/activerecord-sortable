class CreateOtherThings < ActiveRecord::Migration
  def change
    create_table :other_things do |t|
      t.integer :place, :null => false
      t.timestamps
    end

    add_index :other_things, [:place]
  end
end
