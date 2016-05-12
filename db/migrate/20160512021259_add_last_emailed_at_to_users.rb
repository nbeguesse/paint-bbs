class AddLastEmailedAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_emailed_at_post, :datetime
    add_column :users, :last_emailed_at_comment, :datetime
  end
end
