module Spree
  module Api
    class LegacyReturnAuthorizationsController < Spree::Api::BaseController

      def destroy
        @legacy_return_authorization = order.legacy_return_authorizations.accessible_by(current_ability, :destroy).find(params[:id])
        @legacy_return_authorization.destroy
        respond_with(@legacy_return_authorization, status: 204)
      end

      def index
        authorize! :admin, LegacyReturnAuthorization
        @legacy_return_authorizations = order.legacy_return_authorizations.accessible_by(current_ability, :read).
                                 ransack(params[:q]).result.
                                 page(params[:page]).per(params[:per_page])
        respond_with(@legacy_return_authorizations)
      end

      def show
        authorize! :admin, LegacyReturnAuthorization
        @legacy_return_authorization = order.legacy_return_authorizations.accessible_by(current_ability, :read).find(params[:id])
        respond_with(@legacy_return_authorization)
      end

      def update
        @legacy_return_authorization = order.legacy_return_authorizations.accessible_by(current_ability, :update).find(params[:id])
        if @legacy_return_authorization.update_attributes(legacy_return_authorization_params)
          respond_with(@legacy_return_authorization, default_template: :show)
        else
          invalid_resource!(@legacy_return_authorization)
        end
      end

      def add
        @legacy_return_authorization = order.legacy_return_authorizations.accessible_by(current_ability, :update).find(params[:id])
        @legacy_return_authorization.add_variant params[:variant_id].to_i, params[:quantity].to_i
        if @legacy_return_authorization.valid?
          respond_with @legacy_return_authorization, default_template: :show
        else
          invalid_resource!(@legacy_return_authorization)
        end
      end

      def receive
        @legacy_return_authorization = order.legacy_return_authorizations.accessible_by(current_ability, :update).find(params[:id])
        if @legacy_return_authorization.receive
          respond_with @legacy_return_authorization, default_template: :show
        else
          invalid_resource!(@legacy_return_authorization)
        end
      end

      def cancel
        @legacy_return_authorization = order.legacy_return_authorizations.accessible_by(current_ability, :update).find(params[:id])
        if @legacy_return_authorization.cancel
          respond_with @legacy_return_authorization, default_template: :show
        else
          invalid_resource!(@legacy_return_authorization)
        end
      end

      private

      def order
        @order ||= Spree::Order.find_by!(number: order_id)
        authorize! :read, @order
      end

      def legacy_return_authorization_params
        params.require(:legacy_return_authorization).permit(permitted_legacy_return_authorization_attributes)
      end
    end
  end
end
