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

ActiveRecord::Schema.define(version: 2021_07_19_104432) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "api_clients", force: :cascade do |t|
    t.string "name"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "authentication_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["authentication_token"], name: "index_api_clients_on_authentication_token", unique: true
  end

  create_table "audits", force: :cascade do |t|
    t.integer "auditable_id"
    t.string "auditable_type"
    t.integer "associated_id"
    t.string "associated_type"
    t.integer "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.text "audited_changes"
    t.integer "version", default: 0
    t.datetime "created_at"
    t.string "comment"
    t.string "remote_address"
    t.index ["associated_id", "associated_type"], name: "associated_index"
    t.index ["associated_id", "associated_type"], name: "auditable_parent_index"
    t.index ["auditable_id", "auditable_type"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "auth_tokens", force: :cascade do |t|
    t.integer "domain_id"
    t.integer "user_id"
    t.string "token", null: false
    t.text "permissions", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "expires_at", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.integer "domain_id", null: false
    t.string "name", null: false
    t.string "type", limit: 10, null: false
    t.integer "modified_at", null: false
    t.string "account", limit: 40
    t.string "comment", limit: 65535, null: false
    t.index ["domain_id", "modified_at"], name: "comments_order_idx"
    t.index ["domain_id"], name: "comments_domain_id_idx"
    t.index ["name", "type"], name: "comments_name_type_idx"
  end

  create_table "cryptokeys", force: :cascade do |t|
    t.integer "domain_id"
    t.integer "flags", null: false
    t.boolean "active"
    t.text "content"
    t.index ["domain_id"], name: "domainidindex"
  end

  create_table "domainmetadata", force: :cascade do |t|
    t.integer "domain_id"
    t.string "kind", limit: 32
    t.text "content"
    t.index ["domain_id"], name: "domainidmetaindex"
  end

  create_table "domains", force: :cascade do |t|
    t.string "name"
    t.string "master"
    t.integer "last_check"
    t.string "type", default: "NATIVE"
    t.integer "notified_serial"
    t.string "account"
    t.integer "ttl", default: 86400
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.text "notes"
    t.index ["name"], name: "index_domains_on_name"
  end

  create_table "macro_steps", force: :cascade do |t|
    t.integer "macro_id"
    t.string "action"
    t.string "record_type"
    t.string "name"
    t.string "content"
    t.integer "ttl"
    t.integer "prio"
    t.integer "position", null: false
    t.boolean "active", default: true
    t.string "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "macros", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "user_id"
    t.boolean "active", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "record_templates", force: :cascade do |t|
    t.integer "zone_template_id"
    t.string "name"
    t.string "record_type", null: false
    t.string "content", null: false
    t.integer "ttl", null: false
    t.integer "prio"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "records", force: :cascade do |t|
    t.integer "domain_id", null: false
    t.string "name", null: false
    t.string "type", limit: 10, null: false
    t.string "content", limit: 65535, null: false
    t.integer "ttl", null: false
    t.integer "prio"
    t.integer "change_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "disabled", default: false
    t.string "ordername"
    t.boolean "auth", default: true
    t.index ["domain_id", "ordername"], name: "recordorder"
    t.index ["domain_id"], name: "index_records_on_domain_id"
    t.index ["name", "type"], name: "index_records_on_name_and_type"
    t.index ["name"], name: "index_records_on_name"
  end

  create_table "supermasters", id: false, force: :cascade do |t|
    t.string "ip", null: false
    t.string "nameserver", null: false
    t.string "account", limit: 40, null: false
    t.index ["ip", "nameserver"], name: "ip_nameserver_pk", unique: true
  end

  create_table "tsigkeys", force: :cascade do |t|
    t.string "name"
    t.string "algorithm", limit: 50
    t.string "secret"
    t.index ["name", "algorithm"], name: "namealgoindex", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "login"
    t.string "email"
    t.string "encrypted_password", limit: 128, default: "", null: false
    t.string "password_salt", default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "remember_token"
    t.datetime "remember_token_expires_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.string "state", default: "passive"
    t.datetime "deleted_at"
    t.boolean "admin", default: false
    t.boolean "auth_tokens", default: false
    t.datetime "confirmation_sent_at"
    t.string "reset_password_token"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
  end

  create_table "zone_templates", force: :cascade do |t|
    t.string "name"
    t.integer "ttl", default: 86400
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
  end

end
