class AddIsUploadToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :is_upload, :boolean, :default=>false
    add_column :posts, :faq_category, :string
  end
end
