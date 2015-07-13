module Spree
  module PermissionSets
    class LegacyReturnAuthorizationManagement < PermissionSets::Base
      def activate!
        can :manage, Spree::LegacyReturnAuthorization
      end
    end
  end
end
