# frozen_string_literal: true

class ViaCep
  include ::HTTParty

  def self.get(cep: nil)
    response = HTTParty.get("https://viacep.com.br/ws/#{cep}/json/")
    object = response.parsed_response
    ViaCep.serializer(object: object)
  rescue StandardError
    {}
  end

  def self.serializer(object: nil)
    # Retorno padrão da viacep para quando não encontra uma cidade
    if object['localidade'].present?
      state = ::Location::State.by_uf(object['uf']).first
      city = ::Location::City.by_state_id(state.id).by_name(object['localidade']).first
    end

    {
      zipcode: object.try(:[], 'cep'),
      street: object.try(:[], 'logradouro'),
      district: object.try(:[], 'bairro'),
      state: {
        id: state.try(:id),
        uf: state.try(:uf)
      },
      city: {
        id: city.try(:id),
        name: city.try(:name)
      }
    }
  end
end
