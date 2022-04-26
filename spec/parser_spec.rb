require 'ostruct'
require 'byebug'

RSpec.describe F1SalesCustom::Email::Parser do
  context 'when is from website' do
    let(:email) do
      email = OpenStruct.new
      email.to = [email: 'website@savolpeugeto.f1sales.net'],
      email.subject = 'email exemplo savol fiat wordpress',
      email.body = "INFORMAÇÕES DE CONTATO\n\n\n* Campanha:* Ofertas - Savol Fiat -\n* Origem:* Facebook\n\n\n* Nome:* Teste Mauricio F1\n* E-mail: * mauricio.simoes@f1sales.com.br\n* Telefone: * 119123456789\n* Veículo: * Fiorino\n* Loja: * Wandalla.monteiro@savol.com.br\n\n\n* Mensagem: * Teste F1\n\n\n\nATENÇÃO: Não responda este e-mail. Trata-se de uma mensagem informativa e\nautomática.\n\n\nAtenciosamente,\n\n\n<http://www.ange360.com.br>\n\nNada nesta mensagem tem a intenção de ser uma assinatura eletrônica a menos\nque uma declaração específica do contrário seja incluída.\nConfidencialidade: Esta mensagem é destinada somente à pessoa endereçada.\nPode conter material confidencial e/ou privilegiado. Qualquer revisão,\ntransmissão ou outro uso ou ação tomada por confiança é proibida e pode ser\nilegal. Se você recebeu esta mensagem por engano, entre em contato com o\nremetente e apague-a de seu computador."

      email
    end

    let(:parsed_email) { described_class.new(email).parse }

    it 'contains lead website a source name' do
      expect(parsed_email[:source][:name]).to eq(F1SalesCustom::Email::Source.all[0][:name])
    end

    it 'contains name' do
      expect(parsed_email[:customer][:name]).to eq('Teste Mauricio F1')
    end

    it 'contains email' do
      expect(parsed_email[:customer][:email]).to eq('mauricio.simoes@f1sales.com.br')
    end

    it 'contains phone' do
      expect(parsed_email[:customer][:phone]).to eq('119123456789')
    end

    it 'contains message' do
      expect(parsed_email[:message]).to eq('Teste F1')
    end

    it 'contains product' do
      expect(parsed_email[:product][:name]).to eq('Fiorino')
    end

    it 'contains description' do
      expect(parsed_email[:description]).to eq('Campanha: Ofertas - Savol Fiat -; Origem: Facebook; Loja: Wandalla.monteiro@savol.com.br')
    end
  end

  context 'when is from website and has !@#' do
    let(:email) do
      email = OpenStruct.new
      email.to = [email: 'website-seminovos@savolkia.f1sales.org']
      email.subject = 'Oferta / Estoque - Proposta'
      email.body = "!@\#{\n\"CidadeRevenda\":\"Savol Kia (São Bernardo do Campo)\",\n\"Veículo\":\"Sportage \",\n\"Placa\":\"OLL8751\",\n\"Preço\":\"R$ 69.900,00\",\n\"Nome\": \"Guilherme\",\n\"E-mail\": \"guilima@me.com\",\n\"Telefone\": 11998108688,\n\"Descricao\": \"Olá tenho Kia Cerato 2017 e tenho interesse na troca.\"\n}!@#"

      email
    end

    let(:parsed_email) { described_class.new(email).parse }

    it 'contains lead website a source name' do
      expect(parsed_email[:source][:name]).to eq(F1SalesCustom::Email::Source.all[0][:name])
    end

    it 'contains name' do
      expect(parsed_email[:customer][:name]).to eq('Guilherme')
    end

    it 'contains email' do
      expect(parsed_email[:customer][:email]).to eq('guilima@me.com')
    end

    it 'contains phone' do
      expect(parsed_email[:customer][:phone]).to eq('11998108688')
    end

    it 'contains message' do
      expect(parsed_email[:message]).to eq('Olá tenho Kia Cerato 2017 e tenho interesse na troca.')
    end

    it 'contains product' do
      expect(parsed_email[:product][:name]).to eq('Sportage OLL8751')
    end

    it 'contains description' do
      expect(parsed_email[:description]).to eq('Preço R$ 69.900,00')
    end
  end
end
