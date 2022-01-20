require File.expand_path '../spec_helper.rb', __FILE__
require 'ostruct'
require 'byebug'

RSpec.describe F1SalesCustom::Hooks::Lead do
  let(:customer) do
    customer = OpenStruct.new
    customer.name = 'Marcio'
    customer.phone = '1198788899'
    customer.email = 'marcio@f1sales.com.br'

    customer
  end

  let(:lead) do
    lead = OpenStruct.new
    lead.source = source
    lead.customer = customer
    lead.product = product

    lead
  end

  let(:source) do
    source = OpenStruct.new
    source.name = source_name
    source
  end

  let(:product) do
    product = OpenStruct.new
    product.name = product_name

    product
  end

  context 'when product contains "Citroën"' do
    let(:product_name) { 'Citroën C3 picasso OTT8630' }
    let(:source_name) { 'Webmotors - Novos' }

    it 'returns source name' do
      expect(described_class.switch_source(lead)).to eq('Webmotors - Novos - TIME CITROEN')
    end
  end

  context 'when product contains "Peugeot"' do
    let(:product_name) { 'Peugeot 208 RJO1743' }
    let(:source_name) { 'Webmotors - Novos' }

    it 'returns source name' do
      expect(described_class.switch_source(lead)).to eq('Webmotors - Novos - TIME PEUGEOT')
    end
  end

  context 'when product contains license plate with "STO"' do
    let(:product_name) { 'Peugeot 208 STO1743' }
    let(:source_name) { 'Webmotors' }

    it 'returns source name' do
      expect(described_class.switch_source(lead)).to eq('Webmotors - TIME STO USADOS')
    end
  end

  context 'when product contains license plate with "SBC"' do
    let(:product_name) { 'Peugeot 208 SBC1743' }
    let(:source_name) { 'Webmotors' }

    it 'returns source name' do
      expect(described_class.switch_source(lead)).to eq('Webmotors - TIME SBC USADOS')
    end
  end
end
