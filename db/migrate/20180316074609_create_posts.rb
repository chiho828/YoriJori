class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.belongs_to :yori, index: true
      t.string :subtitle
      t.string :main
      t.string :optional
      t.string :seasoning
      t.string :steps
      t.timestamps
    end
  end
end
