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

ActiveRecord::Schema.define(:version => 20130111180241) do

  create_table "assets", :force => true do |t|
    t.string   "access_token",   :null => false
    t.string   "store_name",     :null => false
    t.string   "store_path"
    t.integer  "file_size"
    t.string   "content_type"
    t.string   "description"
    t.string   "extra"
    t.string   "type",           :null => false
    t.string   "assetable_id",   :null => false
    t.string   "assetable_type", :null => false
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "assets", ["access_token"], :name => "index_assets_on_access_token", :unique => true
  add_index "assets", ["assetable_type", "assetable_id"], :name => "index_assets_on_assetable_type_and_assetable_id"

  create_table "authorizations", :force => true do |t|
    t.string   "provider",      :limit => 20, :null => false
    t.string   "uid",           :limit => 20, :null => false
    t.string   "access_token",                :null => false
    t.integer  "expires_at",                  :null => false
    t.string   "refresh_token"
    t.integer  "user_id",                     :null => false
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  add_index "authorizations", ["provider", "uid"], :name => "index_authorizations_on_provider_and_uid", :unique => true
  add_index "authorizations", ["user_id", "provider"], :name => "index_authorizations_on_user_id_and_provider", :unique => true
  add_index "authorizations", ["user_id"], :name => "index_authorizations_on_user_id"

  create_table "comments", :force => true do |t|
    t.string   "title",            :limit => 50, :default => ""
    t.text     "comment",                                                 :null => false
    t.integer  "commentable_id",                                          :null => false
    t.string   "commentable_type",                                        :null => false
    t.integer  "user_id",                                                 :null => false
    t.string   "state",            :limit => 11, :default => "published", :null => false
    t.datetime "created_at",                                              :null => false
    t.datetime "updated_at",                                              :null => false
  end

  add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"
  add_index "comments", ["commentable_type"], :name => "index_comments_on_commentable_type"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "posts", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.integer  "user_id",    :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "posts", ["user_id"], :name => "index_posts_on_user_id"

  create_table "rails_admin_histories", :force => true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      :limit => 2
    t.integer  "year",       :limit => 5
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], :name => "index_rails_admin_histories"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       :limit => 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :limit => 30, :default => "",       :null => false
    t.string   "encrypted_password",                   :default => "",       :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                        :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "province",               :limit => 6
    t.string   "city",                   :limit => 6
    t.string   "district",               :limit => 6
    t.string   "role",                   :limit => 11, :default => "member", :null => false
    t.string   "state",                  :limit => 11, :default => "active", :null => false
    t.datetime "created_at",                                                 :null => false
    t.datetime "updated_at",                                                 :null => false
    t.string   "nickname"
    t.string   "name"
    t.string   "phone"
    t.integer  "age"
    t.integer  "location_id"
    t.boolean  "gender"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["state"], :name => "index_users_on_state"

end
