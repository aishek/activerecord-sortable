class CreateOrderThings < ActiveRecord::Migration
  def change
    create_table :order_things do |t|
      t.integer :order, :null => false

      t.timestamps null: false
    end

    add_index :order_things, [:order]
  end
end
