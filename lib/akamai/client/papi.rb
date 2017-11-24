require "akamai/client/base"

module Akamai
  module Client
    class Papi < Base
      def list_groups
        get(:groups)
      end

      def list_contracts
        get(:contracts)
      end

      def list_custom_behaviors
        get("custom-behaviors")
      end

      def list_products(contract_id)
        get(:products, {contract_id: contract_id})
      end

      def list_cp_codes(contract_id, group_id)
        get(
          :cpcodes,
          {contract_id: contract_id, group_id: group_id} 
        )
      end

      def list_properties(contract_id, group_id)
        get(
          :properties,
          {contract_id: contract_id, group_id: group_id} 
        )
      end

      def get_property(property_id, contract_id, group_id)
        get(
          "properties/#{property_id}",
          {contract_id: contract_id, group_id: group_id} 
        )
      end

      def get_rule_tree(property_id, version, contract_id, group_id, options = {})
        path = build_full_path(
          "properties/#{property_id}/versions/#{version}/rules",
          {contract_id: contract_id, group_id: group_id}.merge(options)
        )
        response = client.get(path)
        transform_to_snakecase(
          response.body[:rules][:behaviors]
        )
      end

      def get_custom_behavior(behavior_id)
        get(
          :custom-behaviors,
          {behavior_id: behavior_id}
        )
      end

      def base_path
        "/papi/v1"
      end
    end
  end
end
