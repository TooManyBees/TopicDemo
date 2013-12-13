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

ActiveRecord::Schema.define(version: 20131213185509) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "articles", force: true do |t|
    t.string   "title",      null: false
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: true do |t|
    t.integer  "parent_id"
    t.text     "content"
    t.integer  "rating",        default: 0
    t.boolean  "visible",       default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "discussion_id",                null: false
    t.text     "quote"
  end

  add_index "comments", ["discussion_id"], name: "index_comments_on_discussion_id", using: :btree
  add_index "comments", ["parent_id"], name: "index_comments_on_parent_id", using: :btree

  create_table "discussions", force: true do |t|
    t.string   "summary",    null: false
    t.integer  "article_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "discussions", ["article_id"], name: "index_discussions_on_article_id", using: :btree

end
