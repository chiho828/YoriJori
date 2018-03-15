class CreateRecipes < ActiveRecord::Migration[5.1]
  def change
    create_table :recipes do |t|
      t.belongs_to :ingredient, index: true
      t.belongs_to :yori, index: true
      t.timestamps
    end
  end
end
