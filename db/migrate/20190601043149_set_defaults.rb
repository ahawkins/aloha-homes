class SetDefaults < ActiveRecord::Migration[5.2]
  def change
    change_column_default(:posts, :liked, false)
    change_column_default(:posts, :discarded, false)

    Post.where(liked: nil).update_all(liked: false)
    Post.where(discarded: nil).update_all(discarded: false)
  end
end
