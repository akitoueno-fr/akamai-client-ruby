require "akamai/client/base"

module Akamai
  module Client
    class Invoice < Base
      def list_invoice_by_account_id(account_id, year, month)
        get("accounts/#{account_id}/invoices", { year: year, month: month })
      end

      def list_invoice_by_contract_id(contract_id, year, month)
        get("contracts/#{contract_id}/invoices", { year: year, month: month })
      end

      def base_path
        "/invoicing-api/v2/"
      end
    end
  end
end
