# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20160509140043) do

  create_table "boards", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "slug"
  end

  create_table "comments", :force => true do |t|
    t.integer  "post_id"
    t.string   "user_id"
    t.string   "user_type"
    t.text     "message"
    t.string   "username"
    t.string   "ip_address"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "friendly_id_slugs", :force => true do |t|
    t.string   "slug",                         :null => false
    t.integer  "sluggable_id",                 :null => false
    t.string   "sluggable_type", :limit => 40
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type"], :name => "index_friendly_id_slugs_on_slug_and_sluggable_type", :unique => true
  add_index "friendly_id_slugs", ["sluggable_id"], :name => "index_friendly_id_slugs_on_sluggable_id"
  add_index "friendly_id_slugs", ["sluggable_type"], :name => "index_friendly_id_slugs_on_sluggable_type"

  create_table "posts", :force => true do |t|
    t.string   "user_id"
    t.string   "user_type"
    t.integer  "board_id"
    t.string   "title"
    t.text     "message"
    t.integer  "paint_time"
    t.string   "slug"
    t.boolean  "in_progress",          :default => false
    t.integer  "image_file_size"
    t.string   "image_content_type"
    t.string   "image_file_name"
    t.datetime "image_updated_at"
    t.integer  "anim_file_size"
    t.string   "anim_content_type"
    t.string   "anim_file_name"
    t.datetime "anim_updated_at"
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.integer  "rotation"
    t.integer  "palette_file_size"
    t.string   "palette_content_type"
    t.string   "palette_file_name"
    t.datetime "palette_updated_at"
    t.string   "username"
    t.string   "ip_address"
    t.boolean  "is_upload",            :default => false
    t.string   "faq_category"
  end

  add_index "posts", ["slug"], :name => "index_posts_on_slug"

  create_table "topics", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "role_name"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.string   "single_access_token"
    t.string   "perishable_token"
    t.integer  "login_count",            :default => 0,     :null => false
    t.integer  "failed_login_count",     :default => 0,     :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.integer  "avatar_file_size"
    t.string   "avatar_content_type"
    t.string   "avatar_file_name"
    t.datetime "avatar_updated_at"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.boolean  "blocked",                :default => false
    t.boolean  "notify_on_new_post",     :default => true
    t.boolean  "notify_on_new_comments", :default => true
  end

end
