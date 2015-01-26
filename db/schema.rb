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

ActiveRecord::Schema.define(version: 20150126203446) do

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority"

  create_table "movies", force: true do |t|
    t.string   "title"
    t.string   "imdb_link"
    t.string   "rotten_tomatoes_link"
    t.string   "amazon_link"
    t.string   "metacritic_link"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "reviews"
    t.integer  "page_depth"
    t.string   "status"
    t.text     "related_people"
    t.string   "rotten_tomatoes_id"
    t.string   "image_url"
    t.integer  "year"
    t.string   "task"
  end

end
