require "akamai/client"
require "akamai/core/client/error"

# This sample provide how to get all rule of properties which you can get. 

client = Akamai::Client::Papi.new(
  host: "akab-xxxx-yyyy.luna.akamaiapis.net",
  client_token: "akab-xxxx-yyyy",
  client_secret: "XXXXyyzz",
  access_token: "akab-xxxx-yyyy"
)
properties = []
client.list_groups.each do |group|
  if group[:contract_ids]
    begin
      properties += client.list_properties(group[:contract_ids][0], group[:group_id])
    rescue Akamai::Core::Client::Error::AkamaiError
      next
    end
  end
end
properties.each do |property|
  client.get_rule_tree(
    property[:property_id],
    property[:latest_version],
    property[:contract_id],
    property[:group_id]
  )
end
