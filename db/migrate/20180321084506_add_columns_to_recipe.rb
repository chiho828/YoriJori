class AddColumnsToRecipe < ActiveRecord::Migration[5.1]
  def change
    add_column :recipes, :main, :boolean
    add_column :recipes, :seasoning, :boolean
    add_column :recipes, :quantity, :integer
    add_column :recipes, :unit, :string
  end
end
