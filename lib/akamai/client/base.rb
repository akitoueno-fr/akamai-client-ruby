require "akamai/core/client"

module Akamai
  module Client
    class Base
      attr_reader :client
      def initialize(host:, client_token:, access_token:, client_secret:)
        @client = Akamai::Core::Client.new(
          host: host,
          client_token: client_token,
          access_token: access_token,
          client_secret: client_secret
        )
      end

      %i(get head delete).each do |method|
        define_method(method) do |resource_name, query_params = {}, headers = {}|
          path = build_full_path(resource_name, query_params)
          response = client.send(method, path, headers)
          return response.body unless :get == method
          build_resources(resource_name, response.body)
        end
      end

      %i(post put patch).each do |method|
        define_method(method) do |resource_name, body, query_params = {}, headers = {}|
          path = build_full_path(resource_name, query_params)
          client.send(method, path, body, headers)
        end
      end

      private

      def build_full_path(resource_name, query_params = {})
        path = URI(File.join(base_path, resource_name.to_s).gsub(/\/$/, ""))
        params = {}.tap do |hash|
          query_params.each do |k, v|
            hash[k.to_s.camelize(:lower)] = v
          end
        end
        path.query = params.present? ? params.to_param : nil
        path.to_s
      end

      def build_resources(resource_name, body)
        if /Array/ =~ body.class.name
          [].tap do |result|
            body.each do |resource|
              result << transform_to_snakecase(resource)
            end
            break result
          end
        else
          items =
            if body.key?(:items)
              body[:items]
            else
              item_key = if /^[a-z1-9]+-[a-z1-9]+$/ =~ resource_name.to_s.split("/")[0]
                           resource_name.to_s.split("/")[0].gsub(/-/, "_").camelize(:lower)
                         else
                           resource_name.to_s.split("/")[0]
                         end
              body[item_key][:items]
            end
          transform_to_snakecase(
            items
          )
        end
      end

      def transform_to_snakecase(data)
        if "Array" == data.class.name
          [].tap do |arr|
            data.each do |element|
              arr << transform_hash(element)
            end
            break arr
          end
        else
          transform_hash(data)
        end
      end

      def transform_hash(element)
        {}.tap do |hash|
          element.each do |k, v|
            hash[k.underscore] = v
          end
        end.with_indifferent_access
      end

      def base_path
        raise(NotImplementedError, "plase override in subclass")
      end
    end
  end
end
