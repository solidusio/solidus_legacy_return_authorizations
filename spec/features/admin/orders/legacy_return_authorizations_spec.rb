require 'spec_helper'

describe "legacy return authorizations" do
  stub_authorization!

  let!(:order) { create(:shipped_order) }

  before do
    create(:legacy_return_authorization,
            :order => order,
            :state => 'authorized',
            :inventory_units => order.shipments.first.inventory_units,
            :stock_location_id => order.shipments.first.stock_location_id)
  end

  # Regression test for #1107
  it "doesn't blow up when receiving a legacy return authorization" do
    visit spree.admin_path
    click_link "Orders"
    click_link order.number
    click_link "Legacy Return Authorizations"
    click_link "Edit"
    lambda { click_button "receive" }.should_not raise_error
  end

end
