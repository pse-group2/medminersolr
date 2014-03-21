
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

ActiveRecord::Schema.define(version: 20140318204737) do

  create_table "archive", primary_key: "ar_id", force: true do |t|
    t.integer "ar_namespace",                       default: 0,                                                                                      null: false
    t.string  "ar_title",                           default: "",                                                                                     null: false
    t.binary  "ar_text",           limit: 16777215,                                                                                                  null: false
    t.binary  "ar_comment",        limit: 255,                                                                                                       null: false
    t.integer "ar_user",                            default: 0,                                                                                      null: false
    t.string  "ar_user_text",                                                                                                                        null: false
    t.binary  "ar_timestamp",      limit: 14,       default: "\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000", null: false
    t.integer "ar_minor_edit",     limit: 1,        default: 0,                                                                                      null: false
    t.binary  "ar_flags",          limit: 255,                                                                                                       null: false
    t.integer "ar_rev_id"
    t.integer "ar_text_id"
    t.integer "ar_deleted",        limit: 1,        default: 0,                                                                                      null: false
    t.integer "ar_len"
    t.integer "ar_page_id"
    t.integer "ar_parent_id"
    t.binary  "ar_sha1",           limit: 32,                                                                                                        null: false
    t.binary  "ar_content_model",  limit: 32
    t.binary  "ar_content_format", limit: 64
  end

  add_index "archive", ["ar_namespace", "ar_title", "ar_timestamp"], name: "name_title_timestamp", using: :btree
  add_index "archive", ["ar_rev_id"], name: "ar_revid", using: :btree
  add_index "archive", ["ar_user_text", "ar_timestamp"], name: "ar_usertext_timestamp", using: :btree

  create_table "articles", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "category", primary_key: "cat_id", force: true do |t|
    t.string  "cat_title",               null: false
    t.integer "cat_pages",   default: 0, null: false
    t.integer "cat_subcats", default: 0, null: false
    t.integer "cat_files",   default: 0, null: false
  end

  add_index "category", ["cat_pages"], name: "cat_pages", using: :btree
  add_index "category", ["cat_title"], name: "cat_title", unique: true, using: :btree

  create_table "categorylinks", id: false, force: true do |t|
    t.integer   "cl_from",                       default: 0,      null: false
    t.string    "cl_to",                         default: "",     null: false
    t.binary    "cl_sortkey",        limit: 230,                  null: false
    t.string    "cl_sortkey_prefix",             default: "",     null: false
    t.timestamp "cl_timestamp",                                   null: false
    t.binary    "cl_collation",      limit: 32,                   null: false
    t.string    "cl_type",           limit: 6,   default: "page", null: false
  end

  add_index "categorylinks", ["cl_collation"], name: "cl_collation", using: :btree
  add_index "categorylinks", ["cl_from", "cl_to"], name: "cl_from", unique: true, using: :btree
  add_index "categorylinks", ["cl_to", "cl_timestamp"], name: "cl_timestamp", using: :btree
  add_index "categorylinks", ["cl_to", "cl_type", "cl_sortkey", "cl_from"], name: "cl_sortkey", using: :btree

  create_table "change_tag", id: false, force: true do |t|
    t.integer "ct_rc_id"
    t.integer "ct_log_id"
    t.integer "ct_rev_id"
    t.string  "ct_tag",    null: false
    t.binary  "ct_params"
  end

  add_index "change_tag", ["ct_log_id", "ct_tag"], name: "change_tag_log_tag", unique: true, using: :btree
  add_index "change_tag", ["ct_rc_id", "ct_tag"], name: "change_tag_rc_tag", unique: true, using: :btree
  add_index "change_tag", ["ct_rev_id", "ct_tag"], name: "change_tag_rev_tag", unique: true, using: :btree
  add_index "change_tag", ["ct_tag", "ct_rc_id", "ct_rev_id", "ct_log_id"], name: "change_tag_tag_id", using: :btree

  create_table "externallinks", primary_key: "el_id", force: true do |t|
    t.integer "el_from",  default: 0, null: false
    t.binary  "el_to",                null: false
    t.binary  "el_index",             null: false
  end

  add_index "externallinks", ["el_from", "el_to"], name: "el_from", length: {"el_from"=>nil, "el_to"=>40}, using: :btree
  add_index "externallinks", ["el_index"], name: "el_index", length: {"el_index"=>60}, using: :btree
  add_index "externallinks", ["el_to", "el_from"], name: "el_to", length: {"el_to"=>60, "el_from"=>nil}, using: :btree

  create_table "filearchive", primary_key: "fa_id", force: true do |t|
    t.string  "fa_name",                               default: "",                                                                                     null: false
    t.string  "fa_archive_name",                       default: ""
    t.binary  "fa_storage_group",     limit: 16
    t.binary  "fa_storage_key",       limit: 64,       default: ""
    t.integer "fa_deleted_user"
    t.binary  "fa_deleted_timestamp", limit: 14,       default: "\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000"
    t.text    "fa_deleted_reason"
    t.integer "fa_size",                               default: 0
    t.integer "fa_width",                              default: 0
    t.integer "fa_height",                             default: 0
    t.binary  "fa_metadata",          limit: 16777215
    t.integer "fa_bits",                               default: 0
    t.string  "fa_media_type",        limit: 10
    t.string  "fa_major_mime",        limit: 11,       default: "unknown"
    t.binary  "fa_minor_mime",        limit: 100,      default: "unknown"
    t.binary  "fa_description",       limit: 255
    t.integer "fa_user",                               default: 0
    t.string  "fa_user_text"
    t.binary  "fa_timestamp",         limit: 14,       default: "\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000"
    t.integer "fa_deleted",           limit: 1,        default: 0,                                                                                      null: false
    t.binary  "fa_sha1",              limit: 32,                                                                                                        null: false
  end

  add_index "filearchive", ["fa_deleted_timestamp"], name: "fa_deleted_timestamp", using: :btree
  add_index "filearchive", ["fa_name", "fa_timestamp"], name: "fa_name", using: :btree
  add_index "filearchive", ["fa_sha1"], name: "fa_sha1", length: {"fa_sha1"=>10}, using: :btree
  add_index "filearchive", ["fa_storage_group", "fa_storage_key"], name: "fa_storage_group", using: :btree
  add_index "filearchive", ["fa_user_text", "fa_timestamp"], name: "fa_user_timestamp", using: :btree

  create_table "hitcounter", id: false, force: true do |t|
    t.integer "hc_id", null: false
  end

  create_table "image", primary_key: "img_name", force: true do |t|
    t.integer "img_size",                         default: 0,         null: false
    t.integer "img_width",                        default: 0,         null: false
    t.integer "img_height",                       default: 0,         null: false
    t.binary  "img_metadata",    limit: 16777215,                     null: false
    t.integer "img_bits",                         default: 0,         null: false
    t.string  "img_media_type",  limit: 10
    t.string  "img_major_mime",  limit: 11,       default: "unknown", null: false
    t.binary  "img_minor_mime",  limit: 100,      default: "unknown", null: false
    t.binary  "img_description", limit: 255,                          null: false
    t.integer "img_user",                         default: 0,         null: false
    t.string  "img_user_text",                                        null: false
    t.binary  "img_timestamp",   limit: 14,                           null: false
    t.binary  "img_sha1",        limit: 32,                           null: false
  end

  add_index "image", ["img_media_type", "img_major_mime", "img_minor_mime"], name: "img_media_mime", using: :btree
  add_index "image", ["img_sha1"], name: "img_sha1", length: {"img_sha1"=>10}, using: :btree
  add_index "image", ["img_size"], name: "img_size", using: :btree
  add_index "image", ["img_timestamp"], name: "img_timestamp", using: :btree
  add_index "image", ["img_user_text", "img_timestamp"], name: "img_usertext_timestamp", using: :btree

  create_table "imagelinks", id: false, force: true do |t|
    t.integer "il_from", default: 0,  null: false
    t.string  "il_to",   default: "", null: false
  end

  add_index "imagelinks", ["il_from", "il_to"], name: "il_from", unique: true, using: :btree
  add_index "imagelinks", ["il_to", "il_from"], name: "il_to", unique: true, using: :btree

  create_table "interwiki", id: false, force: true do |t|
    t.string  "iw_prefix", limit: 32,             null: false
    t.binary  "iw_url",                           null: false
    t.binary  "iw_api",                           null: false
    t.string  "iw_wikiid", limit: 64,             null: false
    t.boolean "iw_local",                         null: false
    t.integer "iw_trans",  limit: 1,  default: 0, null: false
  end

  add_index "interwiki", ["iw_prefix"], name: "iw_prefix", unique: true, using: :btree

  create_table "ipblocks", primary_key: "ipb_id", force: true do |t|
    t.binary  "ipb_address",          limit: 255,                                                                                                  null: false
    t.integer "ipb_user",                         default: 0,                                                                                      null: false
    t.integer "ipb_by",                           default: 0,                                                                                      null: false
    t.string  "ipb_by_text",                      default: "",                                                                                     null: false
    t.binary  "ipb_reason",           limit: 255,                                                                                                  null: false
    t.binary  "ipb_timestamp",        limit: 14,  default: "\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000", null: false
    t.boolean "ipb_auto",                         default: false,                                                                                  null: false
    t.boolean "ipb_anon_only",                    default: false,                                                                                  null: false
    t.boolean "ipb_create_account",               default: true,                                                                                   null: false
    t.boolean "ipb_enable_autoblock",             default: true,                                                                                   null: false
    t.binary  "ipb_expiry",           limit: 14,                                                                                                   null: false
    t.binary  "ipb_range_start",      limit: 255,                                                                                                  null: false
    t.binary  "ipb_range_end",        limit: 255,                                                                                                  null: false
    t.boolean "ipb_deleted",                      default: false,                                                                                  null: false
    t.boolean "ipb_block_email",                  default: false,                                                                                  null: false
    t.boolean "ipb_allow_usertalk",               default: false,                                                                                  null: false
    t.integer "ipb_parent_block_id"
  end

  add_index "ipblocks", ["ipb_address", "ipb_user", "ipb_auto", "ipb_anon_only"], name: "ipb_address", unique: true, length: {"ipb_address"=>255, "ipb_user"=>nil, "ipb_auto"=>nil, "ipb_anon_only"=>nil}, using: :btree
  add_index "ipblocks", ["ipb_expiry"], name: "ipb_expiry", using: :btree
  add_index "ipblocks", ["ipb_parent_block_id"], name: "ipb_parent_block_id", using: :btree
  add_index "ipblocks", ["ipb_range_start", "ipb_range_end"], name: "ipb_range", length: {"ipb_range_start"=>8, "ipb_range_end"=>8}, using: :btree
  add_index "ipblocks", ["ipb_timestamp"], name: "ipb_timestamp", using: :btree
  add_index "ipblocks", ["ipb_user"], name: "ipb_user", using: :btree

  create_table "iwlinks", id: false, force: true do |t|
    t.integer "iwl_from",              default: 0,  null: false
    t.binary  "iwl_prefix", limit: 20,              null: false
    t.string  "iwl_title",             default: "", null: false
  end

  add_index "iwlinks", ["iwl_from", "iwl_prefix", "iwl_title"], name: "iwl_from", unique: true, using: :btree
  add_index "iwlinks", ["iwl_prefix", "iwl_from", "iwl_title"], name: "iwl_prefix_from_title", using: :btree
  add_index "iwlinks", ["iwl_prefix", "iwl_title", "iwl_from"], name: "iwl_prefix_title_from", using: :btree

  create_table "job", primary_key: "job_id", force: true do |t|
    t.binary  "job_cmd",             limit: 60,             null: false
    t.integer "job_namespace",                              null: false
    t.string  "job_title",                                  null: false
    t.binary  "job_timestamp",       limit: 14
    t.binary  "job_params",                                 null: false
    t.integer "job_random",                     default: 0, null: false
    t.integer "job_attempts",                   default: 0, null: false
    t.binary  "job_token",           limit: 32,             null: false
    t.binary  "job_token_timestamp", limit: 14
    t.binary  "job_sha1",            limit: 32,             null: false
  end

  add_index "job", ["job_cmd", "job_namespace", "job_title", "job_params"], name: "job_cmd", length: {"job_cmd"=>nil, "job_namespace"=>nil, "job_title"=>nil, "job_params"=>128}, using: :btree
  add_index "job", ["job_cmd", "job_token", "job_id"], name: "job_cmd_token_id", using: :btree
  add_index "job", ["job_cmd", "job_token", "job_random"], name: "job_cmd_token", using: :btree
  add_index "job", ["job_sha1"], name: "job_sha1", using: :btree
  add_index "job", ["job_timestamp"], name: "job_timestamp", using: :btree

  create_table "l10n_cache", id: false, force: true do |t|
    t.binary "lc_lang",  limit: 32,       null: false
    t.string "lc_key",                    null: false
    t.binary "lc_value", limit: 16777215, null: false
  end

  add_index "l10n_cache", ["lc_lang", "lc_key"], name: "lc_lang_key", using: :btree

  create_table "langlinks", id: false, force: true do |t|
    t.integer "ll_from",             default: 0,  null: false
    t.binary  "ll_lang",  limit: 20,              null: false
    t.string  "ll_title",            default: "", null: false
  end

  add_index "langlinks", ["ll_from", "ll_lang"], name: "ll_from", unique: true, using: :btree
  add_index "langlinks", ["ll_lang", "ll_title"], name: "ll_lang", using: :btree

  create_table "log_search", id: false, force: true do |t|
    t.binary  "ls_field",  limit: 32,             null: false
    t.string  "ls_value",                         null: false
    t.integer "ls_log_id",            default: 0, null: false
  end

  add_index "log_search", ["ls_field", "ls_value", "ls_log_id"], name: "ls_field_val", unique: true, using: :btree
  add_index "log_search", ["ls_log_id"], name: "ls_log_id", using: :btree

  create_table "logging", primary_key: "log_id", force: true do |t|
    t.binary  "log_type",      limit: 32,                            null: false
    t.binary  "log_action",    limit: 32,                            null: false
    t.binary  "log_timestamp", limit: 14, default: "19700101000000", null: false
    t.integer "log_user",                 default: 0,                null: false
    t.string  "log_user_text",            default: "",               null: false
    t.integer "log_namespace",            default: 0,                null: false
    t.string  "log_title",                default: "",               null: false
    t.integer "log_page"
    t.string  "log_comment",              default: "",               null: false
    t.binary  "log_params",                                          null: false
    t.integer "log_deleted",   limit: 1,  default: 0,                null: false
  end

  add_index "logging", ["log_namespace", "log_title", "log_timestamp"], name: "page_time", using: :btree
  add_index "logging", ["log_page", "log_timestamp"], name: "log_page_id_time", using: :btree
  add_index "logging", ["log_timestamp"], name: "times", using: :btree
  add_index "logging", ["log_type", "log_action", "log_timestamp"], name: "type_action", using: :btree
  add_index "logging", ["log_type", "log_timestamp"], name: "type_time", using: :btree
  add_index "logging", ["log_user", "log_timestamp"], name: "user_time", using: :btree
  add_index "logging", ["log_user", "log_type", "log_timestamp"], name: "log_user_type_time", using: :btree
  add_index "logging", ["log_user_text", "log_timestamp"], name: "log_user_text_time", using: :btree
  add_index "logging", ["log_user_text", "log_type", "log_timestamp"], name: "log_user_text_type_time", using: :btree

  create_table "module_deps", id: false, force: true do |t|
    t.binary "md_module", limit: 255,      null: false
    t.binary "md_skin",   limit: 32,       null: false
    t.binary "md_deps",   limit: 16777215, null: false
  end

  add_index "module_deps", ["md_module", "md_skin"], name: "md_module_skin", unique: true, using: :btree

  create_table "msg_resource", id: false, force: true do |t|
    t.binary "mr_resource",  limit: 255,      null: false
    t.binary "mr_lang",      limit: 32,       null: false
    t.binary "mr_blob",      limit: 16777215, null: false
    t.binary "mr_timestamp", limit: 14,       null: false
  end

  add_index "msg_resource", ["mr_resource", "mr_lang"], name: "mr_resource_lang", unique: true, using: :btree

  create_table "msg_resource_links", id: false, force: true do |t|
    t.binary "mrl_resource", limit: 255, null: false
    t.binary "mrl_message",  limit: 255, null: false
  end

  add_index "msg_resource_links", ["mrl_message", "mrl_resource"], name: "mrl_message_resource", unique: true, using: :btree

  create_table "objectcache", primary_key: "keyname", force: true do |t|
    t.binary   "value",   limit: 16777215
    t.datetime "exptime"
  end

  add_index "objectcache", ["exptime"], name: "exptime", using: :btree

  create_table "oldimage", id: false, force: true do |t|
    t.string  "oi_name",                          default: "",                                                                                     null: false
    t.string  "oi_archive_name",                  default: "",                                                                                     null: false
    t.integer "oi_size",                          default: 0,                                                                                      null: false
    t.integer "oi_width",                         default: 0,                                                                                      null: false
    t.integer "oi_height",                        default: 0,                                                                                      null: false
    t.integer "oi_bits",                          default: 0,                                                                                      null: false
    t.binary  "oi_description",  limit: 255,                                                                                                       null: false
    t.integer "oi_user",                          default: 0,                                                                                      null: false
    t.string  "oi_user_text",                                                                                                                      null: false
    t.binary  "oi_timestamp",    limit: 14,       default: "\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000", null: false
    t.binary  "oi_metadata",     limit: 16777215,                                                                                                  null: false
    t.string  "oi_media_type",   limit: 10
    t.string  "oi_major_mime",   limit: 11,       default: "unknown",                                                                              null: false
    t.binary  "oi_minor_mime",   limit: 100,      default: "unknown",                                                                              null: false
    t.integer "oi_deleted",      limit: 1,        default: 0,                                                                                      null: false
    t.binary  "oi_sha1",         limit: 32,                                                                                                        null: false
  end

  add_index "oldimage", ["oi_name", "oi_archive_name"], name: "oi_name_archive_name", length: {"oi_name"=>nil, "oi_archive_name"=>14}, using: :btree
  add_index "oldimage", ["oi_name", "oi_timestamp"], name: "oi_name_timestamp", using: :btree
  add_index "oldimage", ["oi_sha1"], name: "oi_sha1", length: {"oi_sha1"=>10}, using: :btree
  add_index "oldimage", ["oi_user_text", "oi_timestamp"], name: "oi_usertext_timestamp", using: :btree

  create_table "page", primary_key: "page_id", force: true do |t|
    t.integer "page_namespace",                                                                                                                  null: false
    t.string  "page_title",                                                                                                                      null: false
    t.binary  "page_restrictions",  limit: 255,                                                                                                  null: false
    t.integer "page_counter",       limit: 8,   default: 0,                                                                                      null: false
    t.integer "page_is_redirect",   limit: 1,   default: 0,                                                                                      null: false
    t.integer "page_is_new",        limit: 1,   default: 0,                                                                                      null: false
    t.float   "page_random",                                                                                                                     null: false
    t.binary  "page_touched",       limit: 14,  default: "\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000", null: false
    t.binary  "page_links_updated", limit: 14
    t.integer "page_latest",                                                                                                                     null: false
    t.integer "page_len",                                                                                                                        null: false
    t.binary  "page_content_model", limit: 32
  end

  add_index "page", ["page_is_redirect", "page_namespace", "page_len"], name: "page_redirect_namespace_len", using: :btree
  add_index "page", ["page_len"], name: "page_len", using: :btree
  add_index "page", ["page_namespace", "page_title"], name: "name_title", unique: true, using: :btree
  add_index "page", ["page_random"], name: "page_random", using: :btree

  create_table "page_props", id: false, force: true do |t|
    t.integer "pp_page",                null: false
    t.binary  "pp_propname", limit: 60, null: false
    t.binary  "pp_value",               null: false
  end

  add_index "page_props", ["pp_page", "pp_propname"], name: "pp_page_propname", unique: true, using: :btree
  add_index "page_props", ["pp_propname", "pp_page"], name: "pp_propname_page", unique: true, using: :btree

  create_table "page_restrictions", primary_key: "pr_id", force: true do |t|
    t.integer "pr_page",               null: false
    t.binary  "pr_type",    limit: 60, null: false
    t.binary  "pr_level",   limit: 60, null: false
    t.integer "pr_cascade", limit: 1,  null: false
    t.integer "pr_user"
    t.binary  "pr_expiry",  limit: 14
  end

  add_index "page_restrictions", ["pr_cascade"], name: "pr_cascade", using: :btree
  add_index "page_restrictions", ["pr_level"], name: "pr_level", using: :btree
  add_index "page_restrictions", ["pr_page", "pr_type"], name: "pr_pagetype", unique: true, using: :btree
  add_index "page_restrictions", ["pr_type", "pr_level"], name: "pr_typelevel", using: :btree

  create_table "pagelinks", id: false, force: true do |t|
    t.integer "pl_from",      default: 0,  null: false
    t.integer "pl_namespace", default: 0,  null: false
    t.string  "pl_title",     default: "", null: false
  end

  add_index "pagelinks", ["pl_from", "pl_namespace", "pl_title"], name: "pl_from", unique: true, using: :btree
  add_index "pagelinks", ["pl_namespace", "pl_title", "pl_from"], name: "pl_namespace", unique: true, using: :btree

  create_table "protected_titles", id: false, force: true do |t|
    t.integer "pt_namespace",               null: false
    t.string  "pt_title",                   null: false
    t.integer "pt_user",                    null: false
    t.binary  "pt_reason",      limit: 255
    t.binary  "pt_timestamp",   limit: 14,  null: false
    t.binary  "pt_expiry",      limit: 14,  null: false
    t.binary  "pt_create_perm", limit: 60,  null: false
  end

  add_index "protected_titles", ["pt_namespace", "pt_title"], name: "pt_namespace_title", unique: true, using: :btree
  add_index "protected_titles", ["pt_timestamp"], name: "pt_timestamp", using: :btree

  create_table "querycache", id: false, force: true do |t|
    t.binary  "qc_type",      limit: 32,              null: false
    t.integer "qc_value",                default: 0,  null: false
    t.integer "qc_namespace",            default: 0,  null: false
    t.string  "qc_title",                default: "", null: false
  end

  add_index "querycache", ["qc_type", "qc_value"], name: "qc_type", using: :btree

  create_table "querycache_info", id: false, force: true do |t|
    t.binary "qci_type",      limit: 32,                            null: false
    t.binary "qci_timestamp", limit: 14, default: "19700101000000", null: false
  end

  add_index "querycache_info", ["qci_type"], name: "qci_type", unique: true, using: :btree

  create_table "querycachetwo", id: false, force: true do |t|
    t.binary  "qcc_type",         limit: 32,              null: false
    t.integer "qcc_value",                   default: 0,  null: false
    t.integer "qcc_namespace",               default: 0,  null: false
    t.string  "qcc_title",                   default: "", null: false
    t.integer "qcc_namespacetwo",            default: 0,  null: false
    t.string  "qcc_titletwo",                default: "", null: false
  end

  add_index "querycachetwo", ["qcc_type", "qcc_namespace", "qcc_title"], name: "qcc_title", using: :btree
  add_index "querycachetwo", ["qcc_type", "qcc_namespacetwo", "qcc_titletwo"], name: "qcc_titletwo", using: :btree
  add_index "querycachetwo", ["qcc_type", "qcc_value"], name: "qcc_type", using: :btree

  create_table "recentchanges", primary_key: "rc_id", force: true do |t|
    t.binary  "rc_timestamp",  limit: 14,               null: false
    t.binary  "rc_cur_time",   limit: 14,               null: false
    t.integer "rc_user",                   default: 0,  null: false
    t.string  "rc_user_text",                           null: false
    t.integer "rc_namespace",              default: 0,  null: false
    t.string  "rc_title",                  default: "", null: false
    t.string  "rc_comment",                default: "", null: false
    t.integer "rc_minor",      limit: 1,   default: 0,  null: false
    t.integer "rc_bot",        limit: 1,   default: 0,  null: false
    t.integer "rc_new",        limit: 1,   default: 0,  null: false
    t.integer "rc_cur_id",                 default: 0,  null: false
    t.integer "rc_this_oldid",             default: 0,  null: false
    t.integer "rc_last_oldid",             default: 0,  null: false
    t.integer "rc_type",       limit: 1,   default: 0,  null: false
    t.string  "rc_source",     limit: 16,  default: "", null: false
    t.integer "rc_patrolled",  limit: 1,   default: 0,  null: false
    t.binary  "rc_ip",         limit: 40,               null: false
    t.integer "rc_old_len"
    t.integer "rc_new_len"
    t.integer "rc_deleted",    limit: 1,   default: 0,  null: false
    t.integer "rc_logid",                  default: 0,  null: false
    t.binary  "rc_log_type",   limit: 255
    t.binary  "rc_log_action", limit: 255
    t.binary  "rc_params"
  end

  add_index "recentchanges", ["rc_cur_id"], name: "rc_cur_id", using: :btree
  add_index "recentchanges", ["rc_ip"], name: "rc_ip", using: :btree
  add_index "recentchanges", ["rc_namespace", "rc_title"], name: "rc_namespace_title", using: :btree
  add_index "recentchanges", ["rc_namespace", "rc_user_text"], name: "rc_ns_usertext", using: :btree
  add_index "recentchanges", ["rc_new", "rc_namespace", "rc_timestamp"], name: "new_name_timestamp", using: :btree
  add_index "recentchanges", ["rc_timestamp"], name: "rc_timestamp", using: :btree
  add_index "recentchanges", ["rc_user_text", "rc_timestamp"], name: "rc_user_text", using: :btree

  create_table "redirect", primary_key: "rd_from", force: true do |t|
    t.integer "rd_namespace",            default: 0,  null: false
    t.string  "rd_title",                default: "", null: false
    t.string  "rd_interwiki", limit: 32
    t.string  "rd_fragment"
  end

  add_index "redirect", ["rd_namespace", "rd_title", "rd_from"], name: "rd_ns_title", using: :btree

  create_table "revision", primary_key: "rev_id", force: true do |t|
    t.integer "rev_page",                                                                                                                        null: false
    t.integer "rev_text_id",                                                                                                                     null: false
    t.binary  "rev_comment",        limit: 255,                                                                                                  null: false
    t.integer "rev_user",                       default: 0,                                                                                      null: false
    t.string  "rev_user_text",                  default: "",                                                                                     null: false
    t.binary  "rev_timestamp",      limit: 14,  default: "\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000", null: false
    t.integer "rev_minor_edit",     limit: 1,   default: 0,                                                                                      null: false
    t.integer "rev_deleted",        limit: 1,   default: 0,                                                                                      null: false
    t.integer "rev_len"
    t.integer "rev_parent_id"
    t.binary  "rev_sha1",           limit: 32,                                                                                                   null: false
    t.binary  "rev_content_model",  limit: 32
    t.binary  "rev_content_format", limit: 64
  end

  add_index "revision", ["rev_page", "rev_id"], name: "rev_page_id", unique: true, using: :btree
  add_index "revision", ["rev_page", "rev_timestamp"], name: "page_timestamp", using: :btree
  add_index "revision", ["rev_page", "rev_user", "rev_timestamp"], name: "page_user_timestamp", using: :btree
  add_index "revision", ["rev_timestamp"], name: "rev_timestamp", using: :btree
  add_index "revision", ["rev_user", "rev_timestamp"], name: "user_timestamp", using: :btree
  add_index "revision", ["rev_user_text", "rev_timestamp"], name: "usertext_timestamp", using: :btree

  create_table "searchindex", id: false, force: true do |t|
    t.integer "si_page",                                null: false
    t.string  "si_title",                  default: "", null: false
    t.text    "si_text",  limit: 16777215,              null: false
  end

  add_index "searchindex", ["si_page"], name: "si_page", unique: true, using: :btree
  add_index "searchindex", ["si_text"], name: "si_text", type: :fulltext
  add_index "searchindex", ["si_title"], name: "si_title", type: :fulltext

  create_table "site_identifiers", id: false, force: true do |t|
    t.integer "si_site",            null: false
    t.binary  "si_type", limit: 32, null: false
    t.binary  "si_key",  limit: 32, null: false
  end

  add_index "site_identifiers", ["si_key"], name: "site_ids_key", using: :btree
  add_index "site_identifiers", ["si_site"], name: "site_ids_site", using: :btree
  add_index "site_identifiers", ["si_type", "si_key"], name: "site_ids_type", unique: true, using: :btree

  create_table "site_stats", id: false, force: true do |t|
    t.integer "ss_row_id",                               null: false
    t.integer "ss_total_views",   limit: 8, default: 0
    t.integer "ss_total_edits",   limit: 8, default: 0
    t.integer "ss_good_articles", limit: 8, default: 0
    t.integer "ss_total_pages",   limit: 8, default: -1
    t.integer "ss_users",         limit: 8, default: -1
    t.integer "ss_active_users",  limit: 8, default: -1
    t.integer "ss_images",                  default: 0
  end

  add_index "site_stats", ["ss_row_id"], name: "ss_row_id", unique: true, using: :btree

  create_table "sites", primary_key: "site_id", force: true do |t|
    t.binary  "site_global_key", limit: 32, null: false
    t.binary  "site_type",       limit: 32, null: false
    t.binary  "site_group",      limit: 32, null: false
    t.binary  "site_source",     limit: 32, null: false
    t.binary  "site_language",   limit: 32, null: false
    t.binary  "site_protocol",   limit: 32, null: false
    t.string  "site_domain",                null: false
    t.binary  "site_data",                  null: false
    t.boolean "site_forward",               null: false
    t.binary  "site_config",                null: false
  end

  add_index "sites", ["site_domain"], name: "sites_domain", using: :btree
  add_index "sites", ["site_forward"], name: "sites_forward", using: :btree
  add_index "sites", ["site_global_key"], name: "sites_global_key", unique: true, using: :btree
  add_index "sites", ["site_group"], name: "sites_group", using: :btree
  add_index "sites", ["site_language"], name: "sites_language", using: :btree
  add_index "sites", ["site_protocol"], name: "sites_protocol", using: :btree
  add_index "sites", ["site_source"], name: "sites_source", using: :btree
  add_index "sites", ["site_type"], name: "sites_type", using: :btree

  create_table "tag_summary", id: false, force: true do |t|
    t.integer "ts_rc_id"
    t.integer "ts_log_id"
    t.integer "ts_rev_id"
    t.binary  "ts_tags",   null: false
  end

  add_index "tag_summary", ["ts_log_id"], name: "tag_summary_log_id", unique: true, using: :btree
  add_index "tag_summary", ["ts_rc_id"], name: "tag_summary_rc_id", unique: true, using: :btree
  add_index "tag_summary", ["ts_rev_id"], name: "tag_summary_rev_id", unique: true, using: :btree

  create_table "templatelinks", id: false, force: true do |t|
    t.integer "tl_from",      default: 0,  null: false
    t.integer "tl_namespace", default: 0,  null: false
    t.string  "tl_title",     default: "", null: false
  end

  add_index "templatelinks", ["tl_from", "tl_namespace", "tl_title"], name: "tl_from", unique: true, using: :btree
  add_index "templatelinks", ["tl_namespace", "tl_title", "tl_from"], name: "tl_namespace", unique: true, using: :btree

  create_table "text", primary_key: "old_id", force: true do |t|
    t.binary "old_text",  limit: 16777215, null: false
    t.binary "old_flags", limit: 255,      null: false
  end

  create_table "transcache", id: false, force: true do |t|
    t.binary "tc_url",      limit: 255, null: false
    t.text   "tc_contents"
    t.binary "tc_time",     limit: 14,  null: false
  end

  add_index "transcache", ["tc_url"], name: "tc_url_idx", unique: true, using: :btree

  create_table "updatelog", primary_key: "ul_key", force: true do |t|
    t.binary "ul_value"
  end

  create_table "uploadstash", primary_key: "us_id", force: true do |t|
    t.integer "us_user",                    null: false
    t.string  "us_key",                     null: false
    t.string  "us_orig_path",               null: false
    t.string  "us_path",                    null: false
    t.string  "us_source_type",  limit: 50
    t.binary  "us_timestamp",    limit: 14, null: false
    t.string  "us_status",       limit: 50, null: false
    t.integer "us_chunk_inx"
    t.binary  "us_props"
    t.integer "us_size",                    null: false
    t.string  "us_sha1",         limit: 31, null: false
    t.string  "us_mime"
    t.string  "us_media_type",   limit: 10
    t.integer "us_image_width"
    t.integer "us_image_height"
    t.integer "us_image_bits",   limit: 2
  end

  add_index "uploadstash", ["us_key"], name: "us_key", unique: true, using: :btree
  add_index "uploadstash", ["us_timestamp"], name: "us_timestamp", using: :btree
  add_index "uploadstash", ["us_user"], name: "us_user", using: :btree

  create_table "user", primary_key: "user_id", force: true do |t|
    t.string  "user_name",                            default: "",                                                                                                                                                                                                 null: false
    t.string  "user_real_name",                       default: "",                                                                                                                                                                                                 null: false
    t.binary  "user_password",            limit: 255,                                                                                                                                                                                                              null: false
    t.binary  "user_newpassword",         limit: 255,                                                                                                                                                                                                              null: false
    t.binary  "user_newpass_time",        limit: 14
    t.text    "user_email",               limit: 255,                                                                                                                                                                                                              null: false
    t.binary  "user_touched",             limit: 14,  default: "\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000",                                                                                                             null: false
    t.binary  "user_token",               limit: 32,  default: "\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000", null: false
    t.binary  "user_email_authenticated", limit: 14
    t.binary  "user_email_token",         limit: 32
    t.binary  "user_email_token_expires", limit: 14
    t.binary  "user_registration",        limit: 14
    t.integer "user_editcount"
    t.binary  "user_password_expires",    limit: 14
  end

  add_index "user", ["user_email"], name: "user_email", length: {"user_email"=>50}, using: :btree
  add_index "user", ["user_email_token"], name: "user_email_token", using: :btree
  add_index "user", ["user_name"], name: "user_name", unique: true, using: :btree

  create_table "user_former_groups", id: false, force: true do |t|
    t.integer "ufg_user",              default: 0, null: false
    t.binary  "ufg_group", limit: 255,             null: false
  end

  add_index "user_former_groups", ["ufg_user", "ufg_group"], name: "ufg_user_group", unique: true, using: :btree

  create_table "user_groups", id: false, force: true do |t|
    t.integer "ug_user",              default: 0, null: false
    t.binary  "ug_group", limit: 255,             null: false
  end

  add_index "user_groups", ["ug_group"], name: "ug_group", using: :btree
  add_index "user_groups", ["ug_user", "ug_group"], name: "ug_user_group", unique: true, using: :btree

  create_table "user_newtalk", id: false, force: true do |t|
    t.integer "user_id",                        default: 0, null: false
    t.binary  "user_ip",             limit: 40,             null: false
    t.binary  "user_last_timestamp", limit: 14
  end

  add_index "user_newtalk", ["user_id"], name: "un_user_id", using: :btree
  add_index "user_newtalk", ["user_ip"], name: "un_user_ip", using: :btree

  create_table "user_properties", id: false, force: true do |t|
    t.integer "up_user",                 null: false
    t.binary  "up_property", limit: 255, null: false
    t.binary  "up_value"
  end

  add_index "user_properties", ["up_property"], name: "user_properties_property", using: :btree
  add_index "user_properties", ["up_user", "up_property"], name: "user_properties_user_property", unique: true, using: :btree

  create_table "valid_tag", primary_key: "vt_tag", force: true do |t|
  end

  create_table "watchlist", id: false, force: true do |t|
    t.integer "wl_user",                                          null: false
    t.integer "wl_namespace",                        default: 0,  null: false
    t.string  "wl_title",                            default: "", null: false
    t.binary  "wl_notificationtimestamp", limit: 14
  end

  add_index "watchlist", ["wl_namespace", "wl_title"], name: "namespace_title", using: :btree
  add_index "watchlist", ["wl_user", "wl_namespace", "wl_title"], name: "wl_user", unique: true, using: :btree

end

