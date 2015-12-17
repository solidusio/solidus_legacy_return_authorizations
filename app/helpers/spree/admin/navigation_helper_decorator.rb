# This makes it so that the Orders tab is highlighted when we're in the legacy
# return authorization area.

# TODO: Append this to Spree::BackendConfiguration::ORDER_TABS instead of monkey
# patching this method.
Spree::Admin::NavigationHelper.module_eval do
  def tab_with_legacy_return_authorizations(*args, &block)
    if args.first == :orders
      options = args.pop if args.last.is_a?(Hash)
      args << :legacy_return_authorizations
      args << options
    end
    tab_without_legacy_return_authorizations(*args, &block)
  end

  alias_method_chain :tab, :legacy_return_authorizations
end
