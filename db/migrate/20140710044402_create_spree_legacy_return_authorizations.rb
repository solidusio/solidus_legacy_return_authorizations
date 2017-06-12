class CreateSpreeLegacyReturnAuthorizations < SolidusSupport::Migration[4.2]
  def up
    # If this is a migrated database that had legacy returns in it then the table will already exist.
    # But if this is a dev box, etc that's just including this extension then we need to create the table.
    if !table_exists?(:spree_legacy_return_authorizations)
      create_table :spree_legacy_return_authorizations do |t|
        t.string   "number"
        t.string   "state"
        t.decimal  "amount", precision: 10, scale: 2, default: 0.0, null: false
        t.integer  "order_id"
        t.text     "reason"
        t.datetime "created_at"
        t.datetime "updated_at"
        t.integer  "stock_location_id"
      end

      add_column :spree_inventory_units, :legacy_return_authorization_id, :integer
      add_index :spree_inventory_units, :legacy_return_authorization_id
    end
  end

  def down
    drop_table :spree_legacy_return_authorizations
    remove_column :spree_inventory_units, :legacy_return_authorization_id
  end
end
