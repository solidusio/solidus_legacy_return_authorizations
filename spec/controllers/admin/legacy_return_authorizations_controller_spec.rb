require 'spec_helper'

describe Spree::Admin::LegacyReturnAuthorizationsController do
  stub_authorization!

  # Regression test for #1370 #3
  let!(:legacy_return_authorization) { create(:legacy_return_authorization, reason: 'old reason') }

  context "#update" do
    let(:new_reason) { 'new reason' }

    subject do
      put :update, {
        id: legacy_return_authorization.to_param,
        order_id: legacy_return_authorization.order.to_param,
        legacy_return_authorization: {
          :reason => new_reason,
        },
      }
    end

    before { subject }

    it "redirects to legacy return authorizations index" do
      expect(response).to redirect_to(spree.admin_order_legacy_return_authorizations_path(legacy_return_authorization.order))
    end

    it "updates the reason" do
      expect(legacy_return_authorization.reload.reason).to eq new_reason
    end
  end
end
