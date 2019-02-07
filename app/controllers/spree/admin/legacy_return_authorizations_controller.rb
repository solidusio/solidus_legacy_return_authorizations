module Spree
  module Admin
    class LegacyReturnAuthorizationsController < ResourceController
      belongs_to 'spree/order', :find_by => :number

      update.after :associate_inventory_units
      create.after :associate_inventory_units

      def fire
        @legacy_return_authorization.send("#{params[:e]}!")
        flash[:success] = I18n.t('spree.legacy_return_authorization_updated')
        if SolidusSupport.solidus_gem_version < Gem::Version.new('2.0')
          redirect_to :back
        else
          redirect_back(fallback_location: edit_admin_order_legacy_return_authorization_path(@order, @legacy_return_authorization))
        end
      end

      # We don't want to allow creating new legacy RMAs so remove the default methods provided by Admin::ResourceController
      undef new
      undef create

      protected
        def associate_inventory_units
          (params[:return_quantity] || []).each { |variant_id, qty| @legacy_return_authorization.add_variant(variant_id.to_i, qty.to_i) }
        end
    end
  end
end
