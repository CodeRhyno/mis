# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 1) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "branches", force: :cascade do |t|
    t.boolean "active", default: true
    t.text "address"
    t.bigint "circle_id", null: false
    t.string "code"
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["circle_id"], name: "index_branches_on_circle_id"
  end

  create_table "circles", force: :cascade do |t|
    t.boolean "active", default: true
    t.string "code"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.datetime "updated_at", null: false
  end

  create_table "documents", force: :cascade do |t|
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "file_path"
    t.integer "file_size"
    t.string "filename", null: false
    t.bigint "record_id", null: false
    t.string "sha256_hash", null: false
    t.datetime "updated_at", null: false
    t.bigint "uploaded_by_id"
    t.index ["record_id"], name: "index_documents_on_record_id"
    t.index ["sha256_hash"], name: "index_documents_on_sha256_hash"
    t.index ["uploaded_by_id"], name: "index_documents_on_uploaded_by_id"
  end

  create_table "permissions", force: :cascade do |t|
    t.string "action"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "resource_type"
    t.string "title", null: false
    t.datetime "updated_at", null: false
  end

  create_table "record_permissions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "permission_id", null: false
    t.bigint "record_id", null: false
    t.datetime "updated_at", null: false
    t.index ["permission_id"], name: "index_record_permissions_on_permission_id"
    t.index ["record_id"], name: "index_record_permissions_on_record_id"
  end

  create_table "records", force: :cascade do |t|
    t.bigint "branch_id"
    t.bigint "circle_id"
    t.datetime "created_at", null: false
    t.bigint "created_by_id"
    t.text "description"
    t.boolean "objected", default: false
    t.text "objection_reason"
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.boolean "verified", default: false
    t.datetime "verified_at"
    t.bigint "verified_by_id"
    t.index ["branch_id"], name: "index_records_on_branch_id"
    t.index ["circle_id"], name: "index_records_on_circle_id"
    t.index ["created_by_id"], name: "index_records_on_created_by_id"
    t.index ["verified_by_id"], name: "index_records_on_verified_by_id"
  end

  create_table "user_permissions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "permission_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["permission_id"], name: "index_user_permissions_on_permission_id"
    t.index ["user_id", "permission_id"], name: "index_user_permissions_on_user_id_and_permission_id", unique: true
    t.index ["user_id"], name: "index_user_permissions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.boolean "active", default: true
    t.bigint "branch_id"
    t.bigint "circle_id"
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "first_name"
    t.datetime "last_login_at"
    t.string "last_name"
    t.string "password_digest", null: false
    t.string "role", default: "maker", null: false
    t.boolean "suspended", default: false
    t.datetime "updated_at", null: false
    t.index ["branch_id"], name: "index_users_on_branch_id"
    t.index ["circle_id"], name: "index_users_on_circle_id"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "branches", "circles"
  add_foreign_key "documents", "records"
  add_foreign_key "documents", "users", column: "uploaded_by_id"
  add_foreign_key "record_permissions", "permissions"
  add_foreign_key "record_permissions", "records"
  add_foreign_key "records", "branches"
  add_foreign_key "records", "circles"
  add_foreign_key "records", "users", column: "created_by_id"
  add_foreign_key "records", "users", column: "verified_by_id"
  add_foreign_key "user_permissions", "permissions"
  add_foreign_key "user_permissions", "users"
  add_foreign_key "users", "branches"
  add_foreign_key "users", "circles"
end
