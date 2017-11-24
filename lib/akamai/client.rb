require "akamai/client/version"

module Akamai
  module Client
    autoload :VERSION, "akamai/client/version"
    autoload :Base, "akamai/client/base"
    autoload :Papi, "akamai/client/papi"
    autoload :Ccu, "akamai/client/ccu"
  end
end
