require "akamai/client/base"

module Akamai
  module Client
    class Ccu < Base
      def invalidate_cache_by_url(network, targets)
        post(
          "invalidate/url/#{network}",
          build_body(targets) 
        )
      end

      def invalidate_cache_by_cp_code(network, targets)
        post(
          "invalidate/cpcode/#{network}",
          build_body(targets) 
        )
      end

      def invalidate_cache_by_tag(network, targets)
        post(
          "invalidate/tag/#{network}",
          build_body(targets) 
        )
      end

      def delete_cache_by_url(network, targets)
        post(
          "delete/url/#{network}",
          build_body(targets) 
        )
      end

      def delete_cache_by_cp_code(network, targets)
        post(
          "delete/cpcode/#{network}",
          build_body(targets) 
        )
      end

      def delete_cache_by_tag(network, targets)
        post(
          "delete/tag/#{network}",
          build_body(targets) 
        )
      end

      def build_body(targets)
        {
          objects: targets
        }.to_json
      end

      def base_path
        "/ccu/v3"
      end
    end
  end
end
