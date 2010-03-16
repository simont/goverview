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

ActiveRecord::Schema.define(:version => 20100314162651) do

  create_table "annotations", :force => true do |t|
    t.string   "db"
    t.string   "db_object_id"
    t.string   "db_object_symbol"
    t.string   "qualifier"
    t.string   "go_id"
    t.string   "db_reference"
    t.string   "evidence"
    t.string   "with"
    t.string   "aspect"
    t.string   "db_object_name"
    t.string   "db_object_synonym"
    t.string   "taxon"
    t.datetime "date"
    t.string   "assigned_by"
    t.string   "annotation_extension"
    t.string   "gene_product_form_id"
    t.integer  "publication_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "publications", :force => true do |t|
    t.integer  "pmid"
    t.text     "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
