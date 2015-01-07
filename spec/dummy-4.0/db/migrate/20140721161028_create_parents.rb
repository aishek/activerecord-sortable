class CreateParents < ActiveRecord::Migration
  def change
    create_table :parents do |t|
      t.timestamps
    end
  end
end
