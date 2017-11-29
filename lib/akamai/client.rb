require "active_support"
require "active_support/core_ext"
require "akamai/client/version"

module Akamai
  module Client
    autoload :VERSION, "akamai/client/version"
    autoload :Base, "akamai/client/base"
    autoload :Papi, "akamai/client/papi"
    autoload :Ccu, "akamai/client/ccu"
    autoload :Error, "akamai/client/error"
  end
end
