class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :name, null: false, limit: 255
      t.string :code, null: false, limit: 255
      t.text :description, null: false
      t.integer :derivation, null: false
      t.float :price, null: false

      t.references :created_by, index: true, foreign_key: {to_table: :users}
      t.references :updated_by, index: true, foreign_key: {to_table: :users}

      t.boolean :active, index: true, default: true
      t.datetime :deleted_at, index: true

      t.timestamps
    end
  end
end
