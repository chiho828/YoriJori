class AddLikeCountToPost < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :like_count, :integer, default: 0, null: false
  end
end
