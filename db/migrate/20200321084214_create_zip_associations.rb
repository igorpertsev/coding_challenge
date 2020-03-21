class CreateZipAssociations < ActiveRecord::Migration[6.0]
  def change
    create_table :zip_associations, id: false do |t|
      t.integer :zip, null: false
      t.integer :cbsa, null: false

      t.index :zip, unique: true
      t.index :cbsa
    end
  end
end
