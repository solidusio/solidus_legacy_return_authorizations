Spree::Order.class_eval do
  has_many :legacy_return_authorizations, dependent: :destroy

  def awaiting_returns_with_legacy_return_authorizations?
    awaiting_returns_without_legacy_return_authorizations? ||
      legacy_return_authorizations.any? { |legacy_return_authorization| legacy_return_authorization.authorized? }
  end

  alias_method_chain :awaiting_returns?, :legacy_return_authorizations
end
