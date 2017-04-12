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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170412115741) do

  create_table "group_admin_mappings", force: :cascade do |t|
    t.integer  "admin_id"
    t.integer  "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "group_admin_mappings", ["admin_id"], name: "index_group_admin_mappings_on_admin_id"
  add_index "group_admin_mappings", ["group_id"], name: "index_group_admin_mappings_on_group_id"

  create_table "group_poll_competitor_mappings", force: :cascade do |t|
    t.integer  "competitor_id"
    t.integer  "group_poll_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "votes",         default: 0
  end

  add_index "group_poll_competitor_mappings", ["competitor_id"], name: "index_group_poll_competitor_mappings_on_competitor_id"
  add_index "group_poll_competitor_mappings", ["group_poll_id"], name: "index_group_poll_competitor_mappings_on_group_poll_id"

  create_table "group_poll_delete_mappings", force: :cascade do |t|
    t.integer  "group_poll_id"
    t.integer  "user_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "group_poll_delete_mappings", ["group_poll_id"], name: "index_group_poll_delete_mappings_on_group_poll_id"
  add_index "group_poll_delete_mappings", ["user_id"], name: "index_group_poll_delete_mappings_on_user_id"

  create_table "group_poll_voter_mappings", force: :cascade do |t|
    t.integer  "group_poll_id"
    t.integer  "voter_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "group_poll_voter_mappings", ["group_poll_id"], name: "index_group_poll_voter_mappings_on_group_poll_id"
  add_index "group_poll_voter_mappings", ["voter_id"], name: "index_group_poll_voter_mappings_on_voter_id"

  create_table "group_polls", force: :cascade do |t|
    t.string   "name"
    t.integer  "group_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "poll_end",   default: false
  end

  add_index "group_polls", ["group_id"], name: "index_group_polls_on_group_id"

  create_table "group_user_mappings", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "group_user_mappings", ["group_id"], name: "index_group_user_mappings_on_group_id"
  add_index "group_user_mappings", ["user_id"], name: "index_group_user_mappings_on_user_id"

  create_table "groups", force: :cascade do |t|
    t.string   "name"
    t.integer  "no_users"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "images", force: :cascade do |t|
    t.string   "filename"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
  end

  add_index "images", ["user_id"], name: "index_images_on_user_id"

  create_table "uni_poll_admin_mappings", force: :cascade do |t|
    t.integer  "admin_id"
    t.integer  "uni_poll_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "uni_poll_admin_mappings", ["admin_id"], name: "index_uni_poll_admin_mappings_on_admin_id"
  add_index "uni_poll_admin_mappings", ["uni_poll_id"], name: "index_uni_poll_admin_mappings_on_uni_poll_id"

  create_table "uni_poll_competitor_mappings", force: :cascade do |t|
    t.integer  "uni_poll_id"
    t.integer  "votes",           default: 0
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "competitor_name"
  end

  add_index "uni_poll_competitor_mappings", ["uni_poll_id"], name: "index_uni_poll_competitor_mappings_on_uni_poll_id"

  create_table "uni_poll_delete_mappings", force: :cascade do |t|
    t.integer  "uni_poll_id"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "uni_poll_delete_mappings", ["uni_poll_id"], name: "index_uni_poll_delete_mappings_on_uni_poll_id"
  add_index "uni_poll_delete_mappings", ["user_id"], name: "index_uni_poll_delete_mappings_on_user_id"

  create_table "uni_poll_voter_mappings", force: :cascade do |t|
    t.integer  "voter_id"
    t.integer  "uni_poll_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "uni_poll_voter_mappings", ["uni_poll_id"], name: "index_uni_poll_voter_mappings_on_uni_poll_id"
  add_index "uni_poll_voter_mappings", ["voter_id"], name: "index_uni_poll_voter_mappings_on_voter_id"

  create_table "uni_polls", force: :cascade do |t|
    t.string   "name"
    t.boolean  "poll_end",   default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "user_name"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "provider"
    t.string   "uid"
    t.string   "profile_picture"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
