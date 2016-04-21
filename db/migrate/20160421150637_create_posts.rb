class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :user_id
      t.string :user_type
      t.integer :board_id
      t.string :title
      t.text :message
      t.integer :paint_time
      t.string :slug
      t.boolean :in_progress
      t.integer   "image_file_size"
      t.string    "image_content_type"
      t.string    "image_file_name"
      t.datetime  "image_updated_at"
      t.integer   "anim_file_size"
      t.string    "anim_content_type"
      t.string    "anim_file_name"
      t.datetime  "anim_updated_at"

      t.timestamps
    end
  end
end
