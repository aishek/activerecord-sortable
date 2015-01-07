class AddPositionToItems < ActiveRecord::Migration
  def change
    add_column :items, :position, :integer

    Item.order('id desc').each.with_index do |item, position|
      item.update_attribute :position, position
    end

    change_column :items, :position, :integer, :null => false

    add_index :items, [:position]
  end
end
