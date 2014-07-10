Spree::Core::ControllerHelpers::StrongParameters.module_eval do
  def permitted_legacy_return_authorization_attributes
    [:amount, :reason, :stock_location_id]
  end
end
