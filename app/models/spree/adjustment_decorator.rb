Spree::Adjustment.class_eval do
  scope :legacy_return_authorization, -> { where(source_type: "Spree::LegacyReturnAuthorization") }
end
