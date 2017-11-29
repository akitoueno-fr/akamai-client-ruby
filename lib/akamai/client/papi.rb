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
        get(:products, contract_id: contract_id)
      end

      def list_cp_codes(contract_id, group_id)
        get(:cpcodes, ontract_id: contract_id, group_id: group_id)
      end

      def list_properties(contract_id, group_id)
        get(:properties, contract_id: contract_id, group_id: group_id)
      end

      def list_property_versions(property_id, options = {})
        path = build_full_path(
          "properties/#{property_id}/versions", options
        )
        response = client.get(path)
        transform_to_snakecase(
          response.body[:versions][:items]
        )
      end

      def get_property(property_id, contract_id, group_id)
        get(
          "properties/#{property_id}", contract_id: contract_id, group_id: group_id
        )
      end

      def get_rule_tree(property_id, version, options = {})
        path = build_full_path(
          "properties/#{property_id}/versions/#{version}/rules",
          options
        )
        response = client.get(path)
        transform_to_snakecase(
          response.body
        )
      end

      def get_custom_behavior(behavior_id)
        get("custom-behaviors", behavior_id: behavior_id)
      end

      def get_property_version(property_id, version, options = {})
        path = build_full_path(
          "properties/#{property_id}/versions/#{version}",
          options
        )
        response = client.get(path)
        transform_to_snakecase(
          response.body[:versions][:items]
        )[0]
      end

      def get_latest_property_version(property_id, options = {})
        path = build_full_path(
          "properties/#{property_id}/versions/latest",
          options
        )
        client.get(path).body.to_hash["versionLink"].split("/")[-1].to_i
      end

      def create_property_version(property_id, from_version, from_etag, options = {})
        path = build_full_path(
          "properties/#{property_id}/versions",
          options
        )
        body = { createFromVersion: from_version, createFromVersionEtag: from_etag }.to_json
        client.post(path, body).body.to_hash["versionLink"].split("/")[-1].to_i
      end

      def create_new_activation(params, options = {})
        path = build_full_path(
          "properties/#{params[:property_id]}/activations",
          options
        )
        body = {
          notifyEmails: params[:notify_emails] ? params[:notify_emails] : [],
          network: params[:network], propertyVersion: params[:version],
          note: params[:note] ? params[:note] : "", acknowledgeWarnings: []
        }
        retry_create_activation(path, body)
      end

      def update_rule_tree(property_id, version, rules, options = {})
        path = build_full_path(
          "properties/#{property_id}/versions/#{version}/rules",
          options
        )
        body = { rules: rules }.to_json
        client.put(path, body)
      end

      def add_rule(params, options = {})
        params_indiff = params.with_indifferent_access
        rules = get_rule_tree(params_indiff[:property_id], params_indiff[:version], options)[:rules]
        unless params_indiff[:parent_node].blank?
          return add_rule_to_sub_node(params_indiff, rules, options)
        end
        rules[:children] << params_indiff[:rule]
        update_rule_tree(params_indiff[:property_id], params_indiff[:version], rules, options)
      end

      private

      def add_rule_to_sub_node(params, rules, options)
        separator = params[:separator] ? params[:separator] : ":"
        target_nodes = rules[:children]
        params[:parent_node].split(separator).each do |node|
          target_nodes = find_node(node, target_nodes)
        end
        raise(Error::DuplicateError) if target_nodes.select do |child|
                                          child[:name] == params[:rule][:name]
                                        end.present?
        target_nodes << params[:rule]
        update_rule_tree(params[:property_id], params[:version], rules, options)
      end

      def find_node(node, nodes)
        parenet_node = nodes.select do |child|
          child[:name] == node
        end
        raise(Error::NoExistError) if parenet_node.blank?
        parenet_node[0][:children]
      end

      def retry_create_activation(path, body, retry_num = 1)
        client.post(path, body.to_json)
      rescue Akamai::Core::Client::Error::AkamaiError => e
        raise(e) unless retry_num.positive?
        e.body[:warnings].each do |warning|
          body[:acknowledgeWarnings] << warning[:messageId]
        end
        retry_num -= 1
        retry
      end

      def base_path
        "/papi/v1"
      end
    end
  end
end
