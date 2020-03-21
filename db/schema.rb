# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_03_21_094613) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "mdiv_cbsa_associations", id: false, force: :cascade do |t|
    t.integer "cbsa", null: false
    t.integer "mdiv", null: false
    t.index ["mdiv", "cbsa"], name: "index_mdiv_cbsa_associations_on_mdiv_and_cbsa", unique: true
    t.index ["mdiv"], name: "index_mdiv_cbsa_associations_on_mdiv"
  end

  create_table "population_informations", id: false, force: :cascade do |t|
    t.integer "cbsa", null: false
    t.string "name", null: false
    t.string "lsad", null: false
    t.integer "pop_2010"
    t.integer "pop_2011"
    t.integer "pop_2012"
    t.integer "pop_2013"
    t.integer "pop_2014"
    t.integer "pop_2015"
    t.index ["cbsa", "lsad"], name: "index_population_informations_on_cbsa_and_lsad"
    t.index ["cbsa", "name", "lsad"], name: "index_population_informations_on_cbsa_and_name_and_lsad", unique: true
  end

  create_table "zip_associations", id: false, force: :cascade do |t|
    t.integer "zip", null: false
    t.integer "cbsa", null: false
    t.integer "mdiv"
    t.index ["cbsa"], name: "index_zip_associations_on_cbsa"
    t.index ["mdiv"], name: "index_zip_associations_on_mdiv"
    t.index ["zip"], name: "index_zip_associations_on_zip", unique: true
  end

end
