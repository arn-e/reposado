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

ActiveRecord::Schema.define(:version => 20121204053923) do

  create_table "comments", :force => true do |t|
    t.integer  "issue_id"
    t.string   "git_user",   :default => "", :null => false
    t.text     "body"
    t.datetime "date"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "commits", :force => true do |t|
    t.string   "git_user"
    t.datetime "date"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "sha"
    t.string   "parent_sha"
    t.integer  "repository_id"
    t.text     "message"
  end

  create_table "events", :force => true do |t|
    t.datetime "date"
    t.string   "git_user"
    t.string   "status",     :default => "", :null => false
    t.integer  "issue_id"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "issues", :force => true do |t|
    t.integer  "repository_id"
    t.string   "title"
    t.text     "body"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "git_issue_number"
    t.datetime "git_created_at"
    t.datetime "git_updated_at"
  end

  create_table "repositories", :force => true do |t|
    t.string   "url",        :default => "", :null => false
    t.string   "name",       :default => "", :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.text     "chart_data"
  end

end
