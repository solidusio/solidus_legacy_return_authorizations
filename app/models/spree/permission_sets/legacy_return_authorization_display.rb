module Spree
  module PermissionSets
    class LegacyReturnAuthorizationDisplay < PermissionSets::Base
      def activate!
        can [:display, :admin], Spree::LegacyReturnAuthorization
      end
    end
  end
end
