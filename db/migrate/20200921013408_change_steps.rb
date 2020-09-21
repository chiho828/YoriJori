class ChangeSteps < ActiveRecord::Migration[6.0]
  def change
    change_column :posts, :steps, :text
  end
end
