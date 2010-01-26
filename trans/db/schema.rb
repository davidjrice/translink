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

ActiveRecord::Schema.define(:version => 20100126004617) do

  create_table "areas", :force => true do |t|
    t.string "code"
    t.string "name"
  end

  create_table "route_stops", :force => true do |t|
    t.integer "route_id"
    t.integer "stop_id"
    t.integer "order"
  end

  create_table "routes", :force => true do |t|
    t.integer "area_id"
    t.integer "service_id"
    t.string  "code"
    t.string  "name"
  end

  create_table "services", :force => true do |t|
    t.integer "area_id"
    t.string  "code"
    t.string  "name"
  end

  create_table "stops", :force => true do |t|
    t.string "code"
    t.string "name"
    t.string "street"
    t.string "lat"
    t.string "lon"
    t.string "direction"
  end

end
