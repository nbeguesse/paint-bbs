class AddEmailFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :notify_on_new_post, :boolean, :default=>true
    add_column :users, :notify_on_new_comments, :boolean, :default=>true
  end
end
