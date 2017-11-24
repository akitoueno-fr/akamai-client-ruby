require "akamai/client"

# This sample provide how to purge urls specified 

ccu_client = Akamai::Client::Ccu.new(
  host: "akab-xxxx-yyyy.purge.akamaiapis.net",
  client_token: "akab-xxxx-yyyy",
  client_secret: "XXXXyyzz",
  access_token: "akab-xxxx-yyyy"
)
targets = ["https://akamai.sample.net/sp/"]
ccu_client.delete_cache_by_url("staging", targets)
