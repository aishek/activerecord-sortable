class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.timestamps
    end
  end
end
