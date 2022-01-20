# frozen_string_literal: true

require_relative "savolpeugeot/version"
require 'f1sales_custom/hooks'
require "f1sales_helpers"

module Savolpeugeot
  class Error < StandardError; end

  class F1SalesCustom::Hooks::Lead
    class << self
      def switch_source(lead)
        product_name = lead.product ? lead.product.name : ''
        source_name = lead.source ? lead.source.name : ''

        if product_name.downcase.include?('sbc')
          "#{source_name} - TIME SBC USADOS"
        elsif product_name.downcase.include?('sto')
          "#{source_name} - TIME STO USADOS"
        elsif product_name.downcase.include?('citroën') && source_name == 'Webmotors - Novos'
          "#{source_name} - TIME CITROEN"
        elsif product_name.downcase.include?('peugeot') && source_name == 'Webmotors - Novos'
          "#{source_name} - TIME PEUGEOT"
        else
          lead.source.name
        end
      end
    end
  end
end
