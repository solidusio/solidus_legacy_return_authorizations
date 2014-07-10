Spree::InventoryUnit.class_eval do
  belongs_to :legacy_return_authorization, class_name: "Spree::LegacyReturnAuthorization"
end
