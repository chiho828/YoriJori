class CreatePaintings < ActiveRecord::Migration[5.1]
  def self.up
    create_table :paintings do |t|
      t.integer :gallery_id
      t.string :name
      t.string :image
      t.timestamps
    end
  end

  def self.down
    drop_table :paintings
  end
end
