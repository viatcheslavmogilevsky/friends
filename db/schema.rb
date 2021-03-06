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

ActiveRecord::Schema.define(:version => 20120711110446) do

  create_table "comments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "target_user_id"
    t.text     "content"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.datetime "created_at",       :null => false
  end

  create_table "friendships", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "other_user_id"
  end

  add_index "friendships", ["user_id", "other_user_id"], :name => "index_friendships_on_user_id_and_other_user_id", :unique => true

  create_table "likes", :force => true do |t|
    t.integer "user_id"
    t.integer "likeable_id"
    t.string  "likeable_type"
  end

  create_table "messages", :force => true do |t|
    t.integer  "user_id"
    t.integer  "target_user_id"
    t.text     "content"
    t.integer  "mark"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "notifications", :force => true do |t|
    t.integer  "user_id"
    t.integer  "target_user_id"
    t.integer  "notificable_id"
    t.string   "notificable_type"
    t.datetime "created_at",       :null => false
  end

  create_table "photo_albums", :force => true do |t|
    t.integer  "user_id"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "name"
  end

  create_table "photos", :force => true do |t|
    t.integer  "photo_album_id"
    t.integer  "user_id"
    t.text     "description"
    t.string   "content_file_name"
    t.string   "content_content_type"
    t.integer  "content_file_size"
    t.datetime "content_updated_at"
  end

  create_table "posts", :force => true do |t|
    t.integer  "user_id"
    t.text     "content"
    t.integer  "target_user_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  create_table "user_friendships", :force => true do |t|
    t.integer "user_id"
    t.integer "target_user_id"
  end

  add_index "user_friendships", ["user_id", "target_user_id"], :name => "index_friendships_on_ids", :unique => true

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "first_name"
    t.string   "nickname"
    t.text     "description"
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
