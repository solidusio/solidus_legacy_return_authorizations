Deface::Override.new(
  virtual_path: "spree/admin/shared/_order_submenu",
  name: "admin_legacy_return_authorizations_submenu",
  insert_bottom: "[data-hook='admin_order_tabs']",
  text: %q(
    <% if can? :display, Spree::LegacyReturnAuthorization %>
      <% if @order.legacy_return_authorizations.exists? %>
        <li <%= 'class="active"' if current == 'Legacy Return Authorizations' %>>
          <%= link_to_with_icon 'share', I18n.t("spree.legacy_return_authorizations"), admin_order_legacy_return_authorizations_url(@order) %>
        </li>
      <% end %>
    <% end %>
  )
)
