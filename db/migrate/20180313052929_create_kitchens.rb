class CreateKitchens < ActiveRecord::Migration[5.1]
  def change
    create_table :kitchens do |t|
      t.belongs_to :user, index: {unique: true}
      t.string :ingredients
      t.timestamps
    end
  end
end
