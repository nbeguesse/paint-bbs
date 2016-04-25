class AddColumnsToPost < ActiveRecord::Migration
  def change
    change_column :posts, :in_progress, :boolean, :default=>false
    add_column :posts, :rotation, :integer
    add_column :posts, :palette_file_size, :integer
    add_column :posts, :palette_content_type, :string
    add_column :posts, :palette_file_name, :string
    add_column :posts, :palette_updated_at, :datetime
  end
end
