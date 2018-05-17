require "akamai/client/base"

module Akamai
  module Client
    class IdentityManagement < Base
      def list_groups(options = {})
        get(:groups, options)
      end

      def list_roles(options = {})
        get(:roles, options)
      end

      def list_users(options = {})
        get("ui-identities", options)
      end

      def delete_user(user_id)
        delete("ui-identities/#{user_id}")
      end

      private

      def base_path
        "/identity-management/v2/user-admin/"
      end
    end
  end
end
