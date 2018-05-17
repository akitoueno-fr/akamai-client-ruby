require "akamai/client/base"

module Akamai
  module Client
    class Gtm < Base
      def list_domain
        get(:domains)
      end

      def list_data_center(domain_name)
        get("domains/#{domain_name}/datacenters")
      end

      def list_property(domain_name)
        get("domains/#{domain_name}/properties")
      end

      def list_resource(domain_name)
        get("domains/#{domain_name}/resources")
      end

      private

      def base_path
        "/config-gtm/v1/"
      end
    end
  end
end
