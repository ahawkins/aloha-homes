class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string :link, null: false, uniq: true
      t.timestamp :date, null: false
      t.integer :price
      t.integer :bedrooms
      t.integer :bathrooms
      t.string :cover
      t.string :location
      t.integer :sqft
      t.boolean :liked
      t.boolean :discarded
    end

    add_index(:posts, :date)
  end
end
