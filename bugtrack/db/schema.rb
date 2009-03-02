# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090219100956) do

  create_table "accounts", :force => true do |t|
    t.string   "permalink",  :null => false
    t.integer  "user_id",    :null => false
    t.string   "name",       :null => false
    t.string   "time_zone",  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "accounts", ["user_id", "created_at"], :name => "index_accounts_on_user_id_and_created_at"

  create_table "actions", :force => true do |t|
    t.string   "actionable_type", :null => false
    t.integer  "actionable_id",   :null => false
    t.integer  "user_id",         :null => false
    t.integer  "project_id"
    t.string   "what_did"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "actions", ["actionable_type", "actionable_id"], :name => "index_actions_on_actionable_type_and_actionable_id"
  add_index "actions", ["user_id", "created_at"], :name => "index_actions_on_user_id_and_created_at"

  create_table "attachments", :force => true do |t|
    t.integer  "user_id"
    t.string   "attachable_type",               :null => false
    t.integer  "attachable_id",                 :null => false
    t.string   "content_type"
    t.string   "filename",        :limit => 40
    t.string   "thumbnail"
    t.integer  "size"
    t.text     "description"
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "attachments", ["user_id", "created_at"], :name => "index_attachments_on_user_id_and_created_at"
  add_index "attachments", ["attachable_type", "attachable_id"], :name => "index_attachments_on_attachable_type_and_attachable_id"

  create_table "comments", :force => true do |t|
    t.string   "commentable_type", :null => false
    t.integer  "commentable_id",   :null => false
    t.integer  "user_id",          :null => false
    t.text     "comment",          :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_type", "commentable_id", "created_at"], :name => "comments_commentable_idx"
  add_index "comments", ["user_id", "created_at"], :name => "index_comments_on_user_id_and_created_at"

  create_table "milestones", :force => true do |t|
    t.integer  "project_id",  :null => false
    t.string   "name",        :null => false
    t.text     "description"
    t.date     "due_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "milestones", ["project_id", "created_at"], :name => "index_milestones_on_project_id_and_created_at"

  create_table "pages", :force => true do |t|
    t.string   "permalink",                     :null => false
    t.integer  "user_id",                       :null => false
    t.integer  "project_id",                    :null => false
    t.integer  "parent_page_id",                :null => false
    t.integer  "height",         :default => 0, :null => false
    t.string   "title",                         :null => false
    t.text     "body",                          :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pages", ["project_id"], :name => "index_pages_on_project_id"

  create_table "projects", :force => true do |t|
    t.string   "permalink",  :null => false
    t.integer  "account_id", :null => false
    t.string   "name",       :null => false
    t.integer  "type",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "projects", ["permalink"], :name => "index_projects_on_permalink", :unique => true
  add_index "projects", ["account_id", "created_at"], :name => "index_projects_on_account_id_and_created_at"

  create_table "roles", :force => true do |t|
    t.string "name", :null => false
  end

  create_table "settings", :force => true do |t|
    t.integer  "project_id", :null => false
    t.string   "name",       :null => false
    t.text     "value",      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["project_id", "created_at"], :name => "index_settings_on_project_id_and_created_at"

  create_table "subscribes", :force => true do |t|
    t.integer  "ticket_id",  :null => false
    t.integer  "user_id",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subscribes", ["ticket_id", "created_at"], :name => "index_subscribes_on_ticket_id_and_created_at"
  add_index "subscribes", ["user_id", "created_at"], :name => "index_subscribes_on_user_id_and_created_at"

  create_table "tickets", :force => true do |t|
    t.string   "permalink",       :null => false
    t.integer  "created_user_id", :null => false
    t.integer  "responsible_id"
    t.integer  "project_id",      :null => false
    t.integer  "milestone_id"
    t.integer  "priority",        :null => false
    t.string   "title",           :null => false
    t.text     "description"
    t.integer  "state",           :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tickets", ["created_user_id", "created_at"], :name => "index_tickets_on_created_user_id_and_created_at"
  add_index "tickets", ["responsible_id", "created_at"], :name => "index_tickets_on_responsible_id_and_created_at"
  add_index "tickets", ["project_id", "created_at"], :name => "index_tickets_on_project_id_and_created_at"
  add_index "tickets", ["milestone_id", "created_at"], :name => "index_tickets_on_milestone_id_and_created_at"

  create_table "user_accounts", :force => true do |t|
    t.integer "user_id",    :null => false
    t.integer "role_id",    :null => false
    t.integer "account_id", :null => false
  end

  add_index "user_accounts", ["user_id", "role_id", "account_id"], :name => "index_user_accounts_on_user_id_and_role_id_and_account_id"

  create_table "user_projects", :force => true do |t|
    t.integer "user_id",    :null => false
    t.integer "role_id",    :null => false
    t.integer "project_id", :null => false
  end

  add_index "user_projects", ["user_id", "role_id", "project_id"], :name => "index_user_projects_on_user_id_and_role_id_and_project_id"

  create_table "users", :force => true do |t|
    t.integer  "account_id"
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.string   "job_title"
    t.string   "activation_code"
    t.integer  "email_preference"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["account_id", "created_at"], :name => "index_users_on_account_id_and_created_at"

end