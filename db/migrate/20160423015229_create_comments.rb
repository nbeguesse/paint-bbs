class CreateComments < ActiveRecord::Migration
  def change
    add_column :posts, :ip_address, :string
    create_table :comments do |t|
      t.integer :post_id
      t.string :user_id
      t.string :user_type
      t.text :message
      t.string :username
      t.string :ip_address

      t.timestamps
    end
  end
end
