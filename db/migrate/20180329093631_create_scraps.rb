class CreateScraps < ActiveRecord::Migration[5.1]
  def change
    create_table :scraps do |t|
      t.belongs_to :user
      t.belongs_to :post
      t.timestamps
    end
  end
end
