Spree::Api::ApiHelpers.module_eval do
  def legacy_return_authorization_attributes
    [:id, :number, :state, :amount, :order_id, :reason, :created_at, :updated_at]
  end

  self.inventory_unit_attributes << :legacy_return_authorization_id
end
