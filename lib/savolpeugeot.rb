# frozen_string_literal: true

require_relative "savolpeugeot/version"
require 'f1sales_custom/hooks'
require 'f1sales_custom/parser'
require 'f1sales_custom/source'
require "f1sales_helpers"

module Savolpeugeot
  class Error < StandardError; end
  class F1SalesCustom::Email::Source
    def self.all
      [
        {
          email_id: 'website',
          name: 'Website'
        }
      ]
    end
  end

  class F1SalesCustom::Email::Parser
    def parse
      parsed_email = @email.body.colons_to_hash(/(Campanha|Origem|Nome|E-mail|Telefone|Veículo|Loja|Mensagem|ATENÇÃO).*?:/, false)
      source = F1SalesCustom::Email::Source.all[0]
      description = "Campanha: #{parsed_email['campanha']}; Origem: #{parsed_email['origem']}; Loja: #{parsed_email['loja']}"

      {
        source: {
          name: source[:name]
        },
        customer: {
          name: parsed_email['nome'],
          phone: parsed_email['telefone'].tr('^0-9', ''),
          email: parsed_email['email']
        },
        product: { name: parsed_email['veculo'] },
        message: parsed_email['mensagem'],
        description: description
      }
    end
  end

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
