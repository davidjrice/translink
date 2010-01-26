class InitialSchema < ActiveRecord::Migration
  def self.up
    create_table :areas do |t|
      t.string :code
      t.string :name
    end
    
    create_table :services do |t|
      t.integer :area_id
      t.string :code
      t.string :name
    end
    
    create_table :routes do |t|
      t.integer :area_id
      t.integer :service_id
      t.string :code
      t.string :name
    end
    
    create_table :stops do |t|
      t.string :code
      t.string :name
      t.string :street
      t.string :lat
      t.string :lon
      t.string :direction
    end

    create_table :route_stops do |t|
      t.integer :route_id
      t.integer :stop_id
      t.integer :order
    end
    
  end

  def self.down
  end
end
