class CreateMdivCbsaAssociation < ActiveRecord::Migration[6.0]
  def change
    create_table :mdiv_cbsa_associations, id: false do |t|
      t.integer :cbsa, null: false
      t.integer :mdiv, null: false

      t.index [:mdiv, :cbsa], unique: true
      t.index :mdiv
    end
  end
end
