class CreatePopulationInformation < ActiveRecord::Migration[6.0]
  def change
    create_table :population_informations, id: false do |t|
      t.integer :cbsa, null: false
      t.string :name, null: false
      t.string :lsad, null: false
      t.integer :pop_2010
      t.integer :pop_2011
      t.integer :pop_2012
      t.integer :pop_2013
      t.integer :pop_2014
      t.integer :pop_2015

      t.index [:cbsa, :lsad]
      t.index [:cbsa, :name, :lsad], unique: true
    end
  end
end
