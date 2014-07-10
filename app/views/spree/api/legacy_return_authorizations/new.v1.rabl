object false
node(:attributes) { [*legacy_return_authorization_attributes] }
node(:required_attributes) { required_fields_for(Spree::LegacyReturnAuthorization) }
